import SwiftUI
import RecentTradesInterface

struct RecentTradesListView: View {
    @ObservedObject var viewModel: RecentTradesViewModel
    
    let entries: [RecentTradesEntry]
    
    var body: some View {
        ScrollView {
            LazyVStack(spacing: 0) {
                ForEach(entries, id: \.id) { entry in
                    let displayData = viewModel.calculateRowDisplay(
                        entry: entry
                    )
                    
                    RecentTradesRowView(
                        displayData: displayData,
                        hasAnimated: viewModel.hasAniamted(entry.id)
                    ) { viewModel.animated(entry.id) }
                }
            }
        }
    }
}
