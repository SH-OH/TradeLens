import Combine

public protocol WebSocketStateCoordinator: Sendable {
    var webSocketReadyPublisher: AnyPublisher<Bool, Never> { get }
}
