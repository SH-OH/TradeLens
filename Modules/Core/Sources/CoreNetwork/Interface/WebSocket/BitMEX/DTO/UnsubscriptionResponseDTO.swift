public struct UnsubscriptionResponseDTO: Decodable, Sendable {
    public let success: Bool
    public let unsubscribe: String
    public let request: OperationDTO
}
