import CoreNetworkInterface
import Foundation
import OrderBookInterface

final actor OrderBookRepositoryImpl: OrderBookRepository {
    
    private let webSocketRepository: BitMEXWebSocketRepository
    
    init(webSocketRepository: BitMEXWebSocketRepository) {
        self.webSocketRepository = webSocketRepository
    }
    
    nonisolated func disconnect() async {
        await webSocketRepository.disconnect()
    }
    
    nonisolated func observeOrderBook() -> AsyncThrowingStream<OrderBook, Error> {
        return AsyncThrowingStream { continuation in
            Task {
                await observeOrderBook(continuation: continuation)
            }
        }
    }
}

// MARK: - Private Methods

extension OrderBookRepositoryImpl {
    
    private func observeOrderBook(continuation: AsyncThrowingStream<OrderBook, Error>.Continuation) async {
        let stream = webSocketRepository.messageStream(BitMEXMessageResponseDTO<OrderBookEntryDTO>.self)
        
        do {
            for try await response in stream where response.table == "orderBookL2" {
                let orderBookEntries = try response.data.map({ try $0.toDomain(action: response.action) })
                let orderBook = OrderBook(entries: orderBookEntries, action: response.action.toDomain())
                continuation.yield(orderBook)
            }
            continuation.finish()
        } catch {
            continuation.finish(throwing: error)
        }
    }
}
