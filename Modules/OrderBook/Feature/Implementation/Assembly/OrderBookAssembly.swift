import AppRootInterface
import CoreUtils
import CoreNetworkInterface
import OrderBookInterface
import Swinject
import SwiftUI

public final class OrderBookAssembly: Assembly {
    public init() {}
    
    public func assemble(container: Container) {
        container.register(OrderBookRepository.self) { r in
            OrderBookRepositoryImpl(
                webSocketRepository: r.resolve(BitMEXWebSocketRepository.self)
            )
        }
        .inObjectScope(.container)
        
        container.register(OrderBookUseCase.self) { r in
            OrderBookUseCaseImpl(
                repository: r.resolve(OrderBookRepository.self)
            )
        }.inObjectScope(.weak)
        
        container.register(OrderBookViewModel.self) { r in
            OrderBookViewModel(
                useCase: r.resolve(OrderBookUseCase.self),
                webSocketStateCoordinator: r.resolve(WebSocketStateCoordinator.self)
            )
        }.inObjectScope(.weak)
        
        container.register(OrderBookViewFactory.self) { r in
            OrderBookViewFactoryImpl(
                viewModel: r.resolve(OrderBookViewModel.self)
            )
        }
    }
}
