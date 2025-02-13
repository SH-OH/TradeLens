import AppRootInterface
import Foundation
@preconcurrency import Swinject
import CoreNetwork
import OrderBook
import RecentTrades

public final class DIContainer: Sendable {
    
    public static let shared = DIContainer()
    public let container = Container()
    
    private let assembler: Assembler
    
    private init() {
        assembler = Assembler([
            AppRootAssembly(),
            CoreNetworkAssembly(),
            OrderBookAssembly(),
            RecentTradesAssembly(),
        ], container: container)
    }
}
