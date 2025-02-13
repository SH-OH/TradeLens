import CoreNetworkInterface
import Foundation
import RecentTradesInterface

final actor RecentTradesRepositoryImpl: RecentTradesRepository {
    
    private let webSocketRepository: BitMEXWebSocketRepository
    
    init(webSocketRepository: BitMEXWebSocketRepository) {
        self.webSocketRepository = webSocketRepository
    }
    
    nonisolated func disconnect() async {
        await webSocketRepository.disconnect()
    }
    
    nonisolated func observeRecentTrades() -> AsyncThrowingStream<RecentTrades, Error> {
        return AsyncThrowingStream { continuation in
            Task {
                await observeTrades(continuation: continuation)
            }
        }
    }
}

// MARK: - Private Methods

extension RecentTradesRepositoryImpl {
    
    private func observeTrades(continuation: AsyncThrowingStream<RecentTrades, Error>.Continuation) async {
        let stream = webSocketRepository.messageStream(BitMEXMessageResponseDTO<RecentTradesEntryDTO>.self)
        
        do {
            for try await response in stream where response.table == "trade" {
                let entries = try response.data.map({ try $0.toDomain() })
                let recentTrades = RecentTrades(entries: entries, action: response.action.toDomain())
                continuation.yield(recentTrades)
            }
            continuation.finish()
        } catch {
            continuation.finish(throwing: error)
        }
    }
}
