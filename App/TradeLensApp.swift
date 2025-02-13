import SwiftUI
import AppRoot
import OrderBookInterface
import RecentTradesInterface

@main
struct TradeLensApp: App {
    
    private let diContainer: DIContainer = .shared
    
    var body: some Scene {
        WindowGroup {
            let viewModel: MainTabBarViewModel = diContainer.container.resolve(MainTabBarViewModel.self)
            let orderBookViewFactory: OrderBookViewFactory = diContainer.container.resolve(OrderBookViewFactory.self)
            let recentTradesViewFactory: RecentTradesViewFactory = diContainer.container.resolve(RecentTradesViewFactory.self)
            
            MainTabBarView(
                viewModel: viewModel,
                orderBookView: orderBookViewFactory.makeView(),
                recentTrades: recentTradesViewFactory.makeView()
            )
        }
    }
}
