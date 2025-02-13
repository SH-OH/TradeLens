import CoreDomain

public struct BitMEXMessageResponseDTO<T: Decodable & Sendable>: Decodable, Sendable {
    public let table: String
    public let action: Action
    public let data: [T]
    
    public enum Action: String, Decodable, Sendable {
        case partial
        case update
        case delete
        case insert
    }
}

public extension BitMEXMessageResponseDTO.Action {
    func toDomain() -> MessageAction {
        switch self {
        case .partial: return .partial
        case .update: return .update
        case .delete: return .delete
        case .insert: return .insert
        }
    }
}
