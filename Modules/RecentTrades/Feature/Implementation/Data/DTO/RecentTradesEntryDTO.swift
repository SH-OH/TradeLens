import CoreDomain
import Foundation
import RecentTradesInterface

public struct RecentTradesEntryDTO: Decodable, Sendable {
    public let symbol: String
    public let side: String
    public let size: Int
    public let price: Double
    public let timestamp: Date
    public let trdMatchID: String
}

extension RecentTradesEntryDTO {
    func toDomain() throws -> RecentTradesEntry {
        guard let side = Side(rawValue: side.lowercased()) else {
            throw RecentTradesError.decodingFailed(side)
        }
        
        return RecentTradesEntry(
            id: trdMatchID,
            timestamp: timestamp,
            price: price,
            qty: Double(size),
            side: side
        )
    }
}
