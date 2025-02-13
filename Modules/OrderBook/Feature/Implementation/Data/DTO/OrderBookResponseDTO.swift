import CoreNetworkInterface
import CoreDomain
import Foundation
import OrderBookInterface

public struct OrderBookEntryDTO: Decodable, Sendable {
    public let symbol: String
    public let id: Int
    public let side: String
    public let size: Int?
    public let price: Double
}

extension OrderBookEntryDTO {
    func toDomain(action: BitMEXMessageResponseDTO<OrderBookEntryDTO>.Action) throws -> OrderBookEntry {
        guard let side = Side(rawValue: side.lowercased()) else {
            throw OrderBookError.decodingFailed(side)
        }
        
        switch action {
        case .partial, .insert, .update:
            guard let size else {
                throw OrderBookError.decodingFailed(size)
            }
            return OrderBookEntry(
                id: id,
                price: price,
                qty: Double(size),
                side: side
            )
        case .delete:
            return OrderBookEntry(
                id: id,
                price: price,
                qty: 0,
                side: side
            )
        }
    }
}
