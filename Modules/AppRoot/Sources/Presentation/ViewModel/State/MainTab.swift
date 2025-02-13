public enum MainTab: Int, CaseIterable, Sendable {
    case orderBook
    case recentTrades
    
    var title: String {
        switch self {
        case .orderBook: return "Order Book"
        case .recentTrades: return "Recent Trades"
        }
    }
}
