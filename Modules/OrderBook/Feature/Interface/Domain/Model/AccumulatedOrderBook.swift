public struct AccumulatedOrderBook: Hashable, Sendable {
    public let bids: [AccumulatedOrderBookEntry]
    public let asks: [AccumulatedOrderBookEntry]
    public let bidMaxVolume: Double
    public let askMaxVolume: Double
    
    public init(
        bids: [AccumulatedOrderBookEntry],
        asks: [AccumulatedOrderBookEntry],
        bidMaxVolume: Double,
        askMaxVolume: Double
    ) {
        self.bids = bids
        self.asks = asks
        self.bidMaxVolume = bidMaxVolume
        self.askMaxVolume = askMaxVolume
    }
}

public struct AccumulatedOrderBookEntry: Hashable, Sendable {
    public let entry: OrderBookEntry
    public var accumulatedVolume: Double
    
    public init(entry: OrderBookEntry, accumulatedVolume: Double) {
        self.entry = entry
        self.accumulatedVolume = accumulatedVolume
    }
}
