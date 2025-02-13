import Foundation
import OrderBookInterface

final class MockOrderBookRepository: OrderBookRepository, @unchecked Sendable {
    var mockOrderBooks: [OrderBook] = []
    var mockError: Error?
    
    func observeOrderBook() -> AsyncThrowingStream<OrderBook, Error> {
        AsyncThrowingStream { continuation in
            if let error = mockError {
                continuation.finish(throwing: error)
            } else {
                for orderBook in mockOrderBooks {
                    continuation.yield(orderBook)
                }
                continuation.finish()
            }
        }
    }
}
