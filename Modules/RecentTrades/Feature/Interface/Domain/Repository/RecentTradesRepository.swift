public protocol RecentTradesRepository: Sendable {
    func observeRecentTrades() -> AsyncThrowingStream<RecentTrades, Error>
}
