public struct SubscriptionResponseDTO: Decodable, Sendable {
    public let success: Bool
    public let subscribe: String
    public let request: OperationDTO
}
