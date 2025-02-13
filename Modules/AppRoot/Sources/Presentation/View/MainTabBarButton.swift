import SwiftUI

struct MainTabBarButton: View {
    let animation: Namespace.ID
    let tab: MainTab
    let selectedTab: MainTab
    var onSelect: (MainTab) -> Void
    
    var body: some View {
        Button(action: {
            withAnimation(.easeInOut) {
                onSelect(tab)
            }
        }) {
            VStack(spacing: 15) {
                Text(tab.title)
                    .font(.system(.headline, design: .monospaced))
                    .foregroundColor(selectedTab == tab ? .black : .gray)
                
                if selectedTab == tab {
                    MainTabBarIndicator(isSelected: true)
                        .matchedGeometryEffect(id: "underline", in: animation, isSource: selectedTab == tab)
                } else {
                    MainTabBarIndicator(isSelected: false)
                }
            }
        }
        .frame(maxWidth: .infinity)
    }
}
