import SwiftUI

public struct MainTabBarView: View {
    @ObservedObject var viewModel: MainTabBarViewModel
    @Namespace private var animation
    let orderBookView: AnyView
    let recentTrades: AnyView

    public init(
        viewModel: MainTabBarViewModel,
        orderBookView: AnyView,
        recentTrades: AnyView
    ) {
        self.viewModel = viewModel
        self.orderBookView = orderBookView
        self.recentTrades = recentTrades
    }
    
    public var body: some View {
        VStack(spacing: 0) {
            HStack(spacing: 0) {
                ForEach(MainTab.allCases, id: \.self) { tab in
                    MainTabBarButton(
                        animation: animation,
                        tab: tab,
                        selectedTab: viewModel.selectedTab,
                        onSelect: { selectTab in
                            viewModel.selectTab(selectTab)
                        }
                    )
                }
            }
            .frame(height: 44)
            .background(Color.white)
            
            MainTabContentView(
                selectedTab: viewModel.selectedTab,
                orderBookView: orderBookView,
                recentTrades: recentTrades
            )
        }
        .alert("에러", isPresented: $viewModel.isAlertPresented, actions: { [viewModel] in
            Button("확인") {}
            
            Button("재시도") {
                Task(priority: .userInitiated) {
                    try await viewModel.connectWebSocket()
                }
            }
        }, message: {
            Text(viewModel.errorMessage ?? "")
        })
        .task {
            await viewModel.connectWebSocket()
        }
    }
}
