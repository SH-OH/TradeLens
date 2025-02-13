import CoreUI
import SwiftUI

public struct RecentTradesView: View {
    @StateObject private var viewModel: RecentTradesViewModel
    
    public init(viewModel: RecentTradesViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    public var body: some View {
        VStack(spacing: 0) {
            Text("Recent Trades")
                .font(.system(size: 15, weight: .bold, design: .monospaced))
                .foregroundStyle(.gray)
                .frame(maxWidth: .infinity, alignment: .leading)
                .frame(height: 40)
                .padding(.horizontal, 16)
            
            Divider()
            
            HeaderRowView(
                leadingTitle: "Price (USD)",
                centerTitle: "Qty",
                trailingTitle: "Time"
            )
            
            Divider()
            
            RecentTradesListView(
                viewModel: viewModel,
                entries: viewModel.entries
            )
        }
        .alert(
            "에러",
            isPresented: $viewModel.isAlertPresented,
            actions: { [viewModel] in
                Button("확인") {}
                
                Button("재시도") {
                    Task(priority: .userInitiated) {
                        viewModel.startObserveRecentTrades()
                    }
                }
            },
            message: {
            Text(viewModel.errorMessage ?? "")
        })
    }
}
