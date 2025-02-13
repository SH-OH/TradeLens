import Combine
import CoreUI
import SwiftUI

public struct OrderBookView: View {
    @StateObject var viewModel: OrderBookViewModel
    
    public var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                HeaderRowView(
                    leadingTitle: "Qty",
                    centerTitle: "Price (USD)",
                    trailingTitle: "Qty"
                )
                
                Divider()
                
                HStack(spacing: 0) {
                    OrderBookListView(
                        viewModel: viewModel,
                        entries: viewModel.bids,
                        textColor: .green,
                        isBid: true
                    )
                    
                    OrderBookListView(
                        viewModel: viewModel,
                        entries: viewModel.asks,
                        textColor: .red,
                        isBid: false
                    )
                }
                
                Spacer()
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.white)
        .alert(
            "에러",
            isPresented: $viewModel.isAlertPresented,
            actions: { [viewModel] in
                Button("확인") {}
                
                Button("재시도") {
                    Task(priority: .userInitiated) {
                        viewModel.startObserveOrderBook()
                    }
                }
            },
            message: {
            Text(viewModel.errorMessage ?? "")
        })
    }
}
