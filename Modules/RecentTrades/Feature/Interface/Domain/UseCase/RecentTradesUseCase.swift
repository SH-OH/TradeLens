import Combine

public protocol RecentTradesUseCase: Sendable {
    func observeRecentTrades() async throws -> AnyPublisher<[RecentTradesEntry], Error>
}
