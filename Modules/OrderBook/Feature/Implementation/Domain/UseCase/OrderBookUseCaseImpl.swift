import Combine
import CoreDomain
import CoreNetworkInterface
import Foundation
import OrderedCollections
import OrderBookInterface

final class OrderBookUseCaseImpl: OrderBookUseCase {
    
    private enum Const {
        static let maxEntries: Int = 20
        static let cacheEncies: Int = 30
    }
    
    // MARK: - Properties
    
    private let repository: OrderBookRepository
    private let cache: OrderBookCache = .init()
    private let volumeState: VolumeState = .init()
    
    // MARK: - Initialization
    
    init(repository: OrderBookRepository) {
        self.repository = repository
    }
    
    // MARK: - Methods
    
    func observeOrderBook() async throws -> AnyPublisher<AccumulatedOrderBook, Error> {
        return repository.observeOrderBook()
            .toAnyPublisher()
            .flatMap({ orderBook in
                if orderBook.action == .partial {
                    return Just(orderBook)
                        .setFailureType(to: Error.self)
                        .eraseToAnyPublisher()
                } else {
                    return Just(orderBook)
                        .setFailureType(to: Error.self)
                        .buffer(size: 1000, prefetch: .byRequest, whenFull: .dropOldest)
                        .eraseToAnyPublisher()
                }
            })
            .compactMap({ [weak self] in
                self?.process($0)
            })
            .eraseToAnyPublisher()
    }
}

// MARK: - Private Methods

extension OrderBookUseCaseImpl {
    
    private func process(_ orderBook: OrderBook) -> AccumulatedOrderBook {
        let entries = orderBook.entries
        let bidEntries = entries.filter({ $0.side == .buy })
        let askEntries = entries.filter({ $0.side == .sell })
        
        // 1. 기본 Action 처리
        handleAction(orderBook.action, entries: entries)
        
        // 2. 병합 및 정렬 + 20개 제한 + 누적 거래량 계산
        let updatedBids = mergeAndTrimEntries(
            oldEntries: cache.cachedBids,
            newEntries: bidEntries,
            action: orderBook.action,
            isAscending: false
        )
        let updatedAsks = mergeAndTrimEntries(
            oldEntries: cache.cachedAsks,
            newEntries: askEntries,
            action: orderBook.action,
            isAscending: true
        )
        
        // 3. 캐시 저장 (30개)
        cache.updateCachedBids(with: updatedBids.map({ $0.entry }))
        cache.updateCachedAsks(with: updatedAsks.map({ $0.entry }))
        
        // 4. 상위 20개 제한 (뷰 전달용)
        let topBids = updatedBids.prefix(Const.maxEntries).map({ $0 })
        let topAsks = updatedAsks.prefix(Const.maxEntries).map({ $0 })
        
        // 5. 누적 거래량 업데이트
        volumeState.updateMaxVolumes(
            bid: topBids.map({ $0.accumulatedVolume }).max() ?? 0,
            ask: topAsks.map({ $0.accumulatedVolume }).max() ?? 0
        )
        
        // 6. AccumulatedOrderBook 반환
        return AccumulatedOrderBook(
            bids: topBids,
            asks: topAsks,
            bidMaxVolume: volumeState.bidMaxVolume,
            askMaxVolume: volumeState.askMaxVolume
        )
    }
    
    private func handleAction(_ action: MessageAction, entries: [OrderBookEntry]) {
        switch action {
        case .partial:
            cache.clear()
            volumeState.clear()
        case .delete:
            let prices = Set(entries.map(\.price))
            cache.removeEntries(
                side: entries.first?.side ?? .buy,
                targetPrices: prices
            )
        case .insert, .update:
            break
        }
    }
    
    private func mergeAndTrimEntries(
        oldEntries: OrderedDictionary<Double, OrderBookEntry>,
        newEntries: [OrderBookEntry],
        action: MessageAction,
        isAscending: Bool
    ) -> [AccumulatedOrderBookEntry] {
        // 1. 모든 데이터 병합
        var mergedEntries = oldEntries
        
        // 2. 상세 Action 처리
        switch action {
        case .insert, .update:
            for newEntry in newEntries {
                mergedEntries[newEntry.price] = newEntry
            }
            
        case .delete:
            let pricesToDelete = Set(newEntries.map({ $0.price }))
            mergedEntries.removeAll(where: { pricesToDelete.contains($0.key) })
            
        case .partial:
            mergedEntries.removeAll()
            for newEntry in newEntries {
                mergedEntries[newEntry.price] = newEntry
            }
        }
        
        // 3. 정렬 (매수: 높은 가격순, 매도: 낮은 가격순) + 상위 30개 제한 (캐시 저장용)
        let sortedEntries = (
            isAscending
            ? mergedEntries.lazy.sorted(by: { $0.key < $1.key })
            : mergedEntries.lazy.sorted(by: { $0.key > $1.key })
        ).prefix(Const.cacheEncies)
        
        // 4. 누적 거래량 계산 및 캐시에 저장할 데이터
        var accumulatedVolume: Double = 0
        return sortedEntries
            .map({ (_, entry) in
                accumulatedVolume += entry.qty
                return AccumulatedOrderBookEntry(entry: entry, accumulatedVolume: accumulatedVolume)
            })
    }
}
