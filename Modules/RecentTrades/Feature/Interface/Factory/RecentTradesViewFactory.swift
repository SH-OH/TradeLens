import SwiftUI

public protocol RecentTradesViewFactory {
    @MainActor
    func makeView() -> AnyView
}
