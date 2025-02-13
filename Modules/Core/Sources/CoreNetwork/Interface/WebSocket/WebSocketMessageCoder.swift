import Foundation

public protocol WebSocketMessageDecoder: Sendable {
    func decode<T: Decodable & Sendable>(_ message: WebSocketMessage) throws -> T
    
} 

public protocol WebSocketMessageEncoder: Sendable {
    func encode<T: Encodable & Sendable>(_ value: T) throws -> WebSocketMessage
}
