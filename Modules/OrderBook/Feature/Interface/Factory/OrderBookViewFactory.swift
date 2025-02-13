import SwiftUI

public protocol OrderBookViewFactory {
    @MainActor
    func makeView() -> AnyView
}
