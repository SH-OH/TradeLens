import CoreNetworkInterface
import CoreUtils
import Foundation
import Swinject

public final class CoreNetworkAssembly: Assembly {
    public init() {}
    
    public func assemble(container: Container) {
        container.register(WebSocketMessageEncoder.self) { _ in
            JSONWebSocketMessageEncoder()
        }.inObjectScope(.container)
        
        container.register(WebSocketMessageDecoder.self) { _ in
            JSONWebSocketMessageDecoder()
        }.inObjectScope(.container)
        
        container.register(WebSocketServiceProtocol.self) { r in
            WebSocketClient(
                session: URLSession.shared,
                messageCoder: r.resolve(WebSocketMessageEncoder.self)
            )
        }.inObjectScope(.container)
        
        container.register(BitMEXWebSocketRepository.self) { r in
            BitMEXWebSocketRepositoryImpl(
                webSocketClient: r.resolve(WebSocketServiceProtocol.self),
                messageCoder: r.resolve(WebSocketMessageDecoder.self)
            )
        }.inObjectScope(.container)
    }
}
