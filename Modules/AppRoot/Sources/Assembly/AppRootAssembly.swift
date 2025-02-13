import AppRootInterface
import Swinject
import CoreNetworkInterface
import CoreUtils
import OrderBookInterface
import OrderBook
import RecentTrades
import SwiftUI

public final class AppRootAssembly: Assembly {
    public init() {}
    
    public func assemble(container: Container) {
        container.register(WebSocketManagementUseCase.self) { r in
            WebSocketManagementUseCaseImpl(
                webSocketRepository: r.resolve(BitMEXWebSocketRepository.self)
            )
        }
        
        container.register(MainTabBarViewModel.self) { r in
            MainTabBarViewModel(
                selectedTab: .orderBook,
                webSocketManagementUseCase: r.resolve(WebSocketManagementUseCase.self)
            )
        }.inObjectScope(.container)
        
        container.register(WebSocketStateCoordinator.self) { r in
            r.resolve(MainTabBarViewModel.self)
        }.inObjectScope(.container)
    }
}
