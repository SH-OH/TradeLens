import CoreNetworkInterface
import AppRootInterface

package final class WebSocketManagementUseCaseImpl: WebSocketManagementUseCase {
    
    private let webSocketRepository: BitMEXWebSocketRepository
    private let symbol = "XBTUSD"
    
    package init(webSocketRepository: BitMEXWebSocketRepository) {
        self.webSocketRepository = webSocketRepository
    }
    
    package func connect() async throws {
        try await webSocketRepository.connect()
    }
    
    package func subscribeAll() async throws {
        try await webSocketRepository.subscribe(symbol: symbol, topics: "orderBookL2", "trade")
    }
    
    package func disconnect() async {
        await webSocketRepository.disconnect()
    }
}
