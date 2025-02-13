import Foundation
import Combine

public protocol WebSocketClientProtocol {
    func validateConnectionState() async throws
    func connect(target: WebSocketTargetType) async throws
    func disconnect(reason: String?)
    func send<T: Encodable & Sendable>(_ value: T) async throws
}

public protocol WebSocketMessageReceivable {
    func receiveNext() async throws -> URLSessionWebSocketTask.Message
    func messageStream() -> AsyncThrowingStream<URLSessionWebSocketTask.Message, Error>
}

public typealias WebSocketServiceProtocol = WebSocketClientProtocol & WebSocketMessageReceivable & Sendable
