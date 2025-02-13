import Foundation
import CoreNetworkInterface

public struct JSONWebSocketMessageEncoder: WebSocketMessageEncoder {
    
    private let encoder: JSONEncoder
    
    public init(encoder: JSONEncoder = .init()) {
        self.encoder = encoder
        encoder.keyEncodingStrategy = .convertToSnakeCase
    }
    
    public func encode<T: Encodable>(_ value: T) throws -> WebSocketMessage {
        let data = try encoder.encode(value)
        return WebSocketMessage(data: data)
    }
}
