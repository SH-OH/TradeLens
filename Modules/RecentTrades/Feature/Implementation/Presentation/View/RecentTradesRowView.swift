import SwiftUI

struct RecentTradesRowView: View {
    let displayData: RowDisplayItem
    
    @State private var isHighlighted = false
    let hasAnimated: Bool
    let onAnimationComplete: () -> Void
    
    var body: some View {
        HStack {
            Text(String(format: "%.1f", displayData.price))
                .font(.system(size: 13, weight: .medium, design: .monospaced))
                .foregroundColor(displayData.textColor)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            Text(String(format: "%.4f", displayData.qty))
                .font(.system(size: 13, weight: .medium, design: .monospaced))
                .foregroundColor(displayData.textColor)
                .frame(alignment: .center)
            
            Text(displayData.formattedTime)
                .font(.system(size: 13, weight: .medium, design: .monospaced))
                .foregroundColor(displayData.textColor)
                .frame(maxWidth: .infinity, alignment: .trailing)
        }
        .padding(.horizontal, 16)
        .frame(height: 40)
        .frame(maxWidth: .infinity)
        .background(
            backgroundColor
                .animation(.easeOut(duration: 0.2), value: isHighlighted)
        )
        .onAppear {
            if !hasAnimated {
                isHighlighted = true
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                    isHighlighted = false
                    onAnimationComplete()
                }
            }
        }
    }
    
    private var backgroundColor: Color {
        guard isHighlighted else { return .clear }
        return displayData.textColor.opacity(0.3)
    }
}

#Preview {
    VStack {
        RecentTradesRowView(
            displayData: .init(
                id: "buy-test",
                price: 51839.4,
                qty: 965,
                timestamp: Date.now - 100,
                side: .buy
            ), hasAnimated: false) {
                
            }
        
        Divider()
        
        RecentTradesRowView(
            displayData: .init(
                id: "sell-test",
                price: 51839.4,
                qty: 965,
                timestamp: Date.now - 200,
                side: .sell
            ), hasAnimated: false) {
                
            }
    }
}
