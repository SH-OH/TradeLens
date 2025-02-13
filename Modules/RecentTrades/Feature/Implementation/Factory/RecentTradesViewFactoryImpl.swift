import SwiftUI
import RecentTradesInterface

public final class RecentTradesViewFactoryImpl: RecentTradesViewFactory {
    private let viewModel: RecentTradesViewModel
    
    public init(viewModel: RecentTradesViewModel) {
        self.viewModel = viewModel
    }
    
    public func makeView() -> AnyView {
        AnyView(
            RecentTradesView(
                viewModel: self.viewModel
            )
        )
    }
}
