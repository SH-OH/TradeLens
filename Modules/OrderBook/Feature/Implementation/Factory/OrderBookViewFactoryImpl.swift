import SwiftUI
import OrderBookInterface

public final class OrderBookViewFactoryImpl: OrderBookViewFactory {
    private let viewModel: OrderBookViewModel
    
    public init(viewModel: OrderBookViewModel) {
        self.viewModel = viewModel
    }
    
    public func makeView() -> AnyView {
        AnyView(
            OrderBookView(
                viewModel: self.viewModel
            )
        )
    }
}
