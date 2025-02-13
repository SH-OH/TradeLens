import SwiftUI
import OrderBookInterface

struct OrderBookListView: View {
    @ObservedObject var viewModel: OrderBookViewModel
    
    let entries: [AccumulatedOrderBookEntry]
    let textColor: Color
    let isBid: Bool
    
    var body: some View {
        VStack {
            LazyVStack(spacing: 1) {
                ForEach(entries, id: \.entry) { entry in
                    let displayData = viewModel.calculateRowDisplay(
                        entry: entry,
                        maxVolume: isBid ? viewModel.bidMaxVolume : viewModel.askMaxVolume
                    )
                    
                    OrderBookRowView(
                        displayData: displayData,
                        textColor: textColor,
                        isBid: isBid
                    )
                }
            }
            Spacer()
        }
        .frame(maxWidth: .infinity, alignment: .top)
    }
}
