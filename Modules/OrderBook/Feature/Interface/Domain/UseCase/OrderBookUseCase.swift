import Combine
import Foundation
import OrderBookInterface

public protocol OrderBookUseCase: Sendable {
    func observeOrderBook() async throws -> AnyPublisher<AccumulatedOrderBook, Error>
}
