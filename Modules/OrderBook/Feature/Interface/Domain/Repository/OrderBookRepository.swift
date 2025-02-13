import Foundation

public protocol OrderBookRepository: Sendable {
    func observeOrderBook() -> AsyncThrowingStream<OrderBook, Error>
}
