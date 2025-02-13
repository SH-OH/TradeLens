import SwiftUI

struct MainTabBarIndicator: View {
    let isSelected: Bool

    var body: some View {
        ZStack {
            Rectangle()
                .fill(Color.gray.opacity(0.3))
                .frame(height: 2)
            
            if isSelected {
                Rectangle()
                    .fill(.mint)
                    .frame(height: 2.5)
                    .padding(.horizontal, isSelected ? 16 : 0)
                    .animation(.easeInOut, value: isSelected)
            }
        }
    }
}
