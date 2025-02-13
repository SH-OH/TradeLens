import Foundation
import RecentTradesInterface

final class RecentTradesCache: @unchecked Sendable {
    
    var entries: [RecentTradesEntry] {
        queue.sync { _entries }
    }
    
    private let queue: DispatchQueue = .init(label: "com.SH-OH.TradeLens.RecentTrades.RecentTradesCache")
    
    private var _entries: [RecentTradesEntry] = []
    
    func insertEntries(contentsOf newEntries: [RecentTradesEntry], at i: Int) {
        queue.sync {
            self._entries.insert(contentsOf: newEntries, at: i)
        }
    }
    
    func updateEntries(newEntries: [RecentTradesEntry]) {
        queue.sync {
            self._entries = newEntries
        }
    }
    
    func clear() {
        queue.sync {
            self._entries.removeAll(keepingCapacity: true)
        }
    }
}
