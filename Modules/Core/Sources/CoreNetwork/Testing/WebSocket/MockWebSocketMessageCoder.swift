import Foundation
import CoreNetworkInterface

final class MockWebSocketMessageCoder: WebSocketMessageCoder, @unchecked Sendable {
    var encodedMessages: [Any] = []
    var decodedMessages: [WebSocketMessage] = []
    
    var valueToReturn: Any?
    var errorToThrow: Error?
    
    func decode<T: Decodable & Sendable>(_ message: WebSocketMessage) throws -> T {
        decodedMessages.append(message)
        
        if let error = errorToThrow {
            throw error
        }
        
        guard let value = valueToReturn as? T else {
            throw NSError(domain: "Invalid value type", code: -1)
        }
        
        return value
    }
    
    func encode<T: Encodable & Sendable>(_ value: T) throws -> WebSocketMessage {
        encodedMessages.append(value)
        
        if let error = errorToThrow {
            throw error
        }
        
        return WebSocketMessage(data: Data())
    }
}
