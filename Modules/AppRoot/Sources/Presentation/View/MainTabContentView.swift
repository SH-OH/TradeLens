import SwiftUI

struct MainTabContentView: View {
    let selectedTab: MainTab
    let orderBookView: AnyView
    let recentTrades: AnyView
    
    var body: some View {
        switch selectedTab {
        case .orderBook:
            orderBookView
        case .recentTrades:
            recentTrades
        }
    }
}
