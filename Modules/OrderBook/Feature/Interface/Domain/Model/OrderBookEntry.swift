import CoreDomain

public struct OrderBook: Sendable {
    public let entries: [OrderBookEntry]
    public let action: MessageAction
    
    public init(entries: [OrderBookEntry], action: MessageAction) {
        self.entries = entries
        self.action = action
    }
}

public struct OrderBookEntry: Hashable, Sendable {
    public let id: Int
    public let price: Double
    public let qty: Double
    public let side: Side
    
    public init(
        id: Int,
        price: Double,
        qty: Double,
        side: Side
    ) {
        self.id = id
        self.price = price
        self.qty = qty
        self.side = side
    }
}
