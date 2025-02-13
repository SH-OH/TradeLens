import Foundation
import Combine
import OrderBookInterface

final class MockOrderBookUseCase: OrderBookUseCase, @unchecked Sendable {
    
    public func observeOrderBook() async throws -> AnyPublisher<AccumulatedOrderBook, Error> {
        let basePrice = 51000.0
        let bids = (0..<20).map { i -> AccumulatedOrderBookEntry in
            let price = basePrice - Double(i * 10)
            return AccumulatedOrderBookEntry(
                entry: .init(
                    id: i,
                    price: price,
                    qty: Double(Int.random(in: 1...3)),
                    side: .buy
                ),
                accumulatedVolume: Double(Int.random(in: 1...100))
            )
        }
        let bidsMaxVolume = bids.map(\.accumulatedVolume).max() ?? 1
        
        let asks = (0..<20).map { i -> AccumulatedOrderBookEntry in
            let price = basePrice + Double(i * 10)
            return AccumulatedOrderBookEntry(
                entry: .init(
                    id: i + 100,
                    price: price,
                    qty: Double(Int.random(in: 1...3)),
                    side: .sell
                ),
                accumulatedVolume: Double(Int.random(in: 100...1000))
            )
        }
        let asksMaxVolume = bids.map(\.accumulatedVolume).max() ?? 1
        
        return Just(AccumulatedOrderBook(bids: bids, asks: asks, bidMaxVolume: bidsMaxVolume, askMaxVolume: asksMaxVolume))
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }
}
