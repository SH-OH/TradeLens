import Foundation

final class VolumeState: @unchecked Sendable {
    private var _bidMaxVolume: Double = 0
    private var _askMaxVolume: Double = 0
    
    private let queue: DispatchQueue = .init(label: "com.SH-OH.Filpster-pre-task.OrderBook.VolumeState")
    
    var bidMaxVolume: Double {
        queue.sync { _bidMaxVolume }
    }
    var askMaxVolume: Double {
        queue.sync { _askMaxVolume }
    }
    
    func updateMaxVolumes(bid: Double, ask: Double) {
        queue.sync {
            self._bidMaxVolume = max(self._bidMaxVolume, bid)
            self._askMaxVolume = max(self._askMaxVolume, ask)
        }
    }
    
    func clear() {
        queue.sync {
            self._bidMaxVolume = 0
            self._askMaxVolume = 0
        }
    }
}
