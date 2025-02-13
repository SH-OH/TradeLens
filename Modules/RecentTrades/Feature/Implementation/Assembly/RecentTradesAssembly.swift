import AppRootInterface
import CoreUtils
import CoreNetworkInterface
import RecentTradesInterface
import Swinject
import SwiftUI

public final class RecentTradesAssembly: Assembly {
    public init() {}
    
    public func assemble(container: Container) {
        container.register(RecentTradesRepository.self) { r in
            RecentTradesRepositoryImpl(
                webSocketRepository: r.resolve(BitMEXWebSocketRepository.self)
            )
        }
        .inObjectScope(.container)
        
        container.register(RecentTradesUseCase.self) { r in
            RecentTradesUseCaseImpl(
                repository: r.resolve(RecentTradesRepository.self)
            )
        }.inObjectScope(.weak)
        
        container.register(RecentTradesViewModel.self) { r in
            RecentTradesViewModel(
                useCase: r.resolve(RecentTradesUseCase.self),
                webSocketStateCoordinator: r.resolve(WebSocketStateCoordinator.self)
            )
        }.inObjectScope(.weak)
        
        container.register(RecentTradesViewFactory.self) { r in
            RecentTradesViewFactoryImpl(
                viewModel: r.resolve(RecentTradesViewModel.self)
            )
        }
    }
}
