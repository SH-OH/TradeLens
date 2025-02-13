import Foundation

public struct WebSocketMessage {
    public let data: Data
    
    public init(data: Data) {
        self.data = data
    }
}
