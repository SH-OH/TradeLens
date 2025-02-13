import CoreDomain
import Foundation

public struct RecentTrades: Sendable {
    public let entries: [RecentTradesEntry]
    public let action: MessageAction
    
    public init(entries: [RecentTradesEntry], action: MessageAction) {
        self.entries = entries
        self.action = action
    }
}

public struct RecentTradesEntry: Hashable, Sendable {
    public let id: String
    public let timestamp: Date
    public let price: Double
    public let qty: Double
    public let side: Side
    
    public init(
        id: String,
        timestamp: Date,
        price: Double,
        qty: Double,
        side: Side
    ) {
        self.id = id
        self.timestamp = timestamp
        self.price = price
        self.qty = qty
        self.side = side
    }
}
