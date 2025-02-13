import Foundation
import Combine

public protocol BitMEXWebSocketRepository: Sendable {
    func connect() async throws
    func subscribe(symbol: String, topics: String...) async throws
    func unsubscribe(symbol: String, topics: String...) async throws
    func disconnect() async
    func messageStream<T: Decodable & Sendable>(_ type: T.Type) -> AsyncThrowingStream<T, Error>
}
