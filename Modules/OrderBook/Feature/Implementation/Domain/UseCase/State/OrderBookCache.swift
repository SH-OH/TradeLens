import CoreDomain
import Foundation
import OrderedCollections
import OrderBookInterface

final class OrderBookCache: @unchecked Sendable {
    private var _cachedBids: OrderedDictionary<Double, OrderBookEntry> = [:]
    private var _cachedAsks: OrderedDictionary<Double, OrderBookEntry> = [:]
    
    private let queue = DispatchQueue(label: "com.SH-OH.Filpster-pre-task.OrderBook.OrderBookCache")
    
    var cachedBids: OrderedDictionary<Double, OrderBookEntry> {
        queue.sync { _cachedBids }
    }
    var cachedAsks: OrderedDictionary<Double, OrderBookEntry> {
        queue.sync { _cachedAsks }
    }
    
    func updateCachedBids(with newEntries: [OrderBookEntry]) {
        queue.sync {
            self.updateCache(with: &self._cachedBids, newEntries: newEntries)
        }
    }
    
    func updateCachedAsks(with newEntries: [OrderBookEntry]) {
        queue.sync {
            self.updateCache(with: &self._cachedAsks, newEntries: newEntries)
        }
    }
    
    func removeEntries(side: Side, targetPrices: Set<Double>) {
        queue.sync {
            if side == .buy {
                self._cachedBids.removeAll(where: { targetPrices.contains($0.key) })
            } else {
                self._cachedAsks.removeAll(where: { targetPrices.contains($0.key) })
            }
        }
    }
    
    func clear() {
        queue.sync {
            self._cachedBids.removeAll()
            self._cachedAsks.removeAll()
        }
    }
}

extension OrderBookCache {
    private func updateCache(
        with cache: inout OrderedDictionary<Double, OrderBookEntry>,
        newEntries: [OrderBookEntry]
    ) {
        let dictionary = OrderedDictionary(uniqueKeysWithValues: newEntries.map { ($0.price, $0) })
        cache.merge(dictionary) { (_, new) in new }
        
        let newPrices = Set(newEntries.map { $0.price })
        cache.removeAll { !newPrices.contains($0.key) }
    }
}
