import Foundation
import CoreNetworkInterface

public struct JSONWebSocketMessageDecoder: WebSocketMessageDecoder {
    
    private let decoder: JSONDecoder
    
    public init(decoder: JSONDecoder = .init()) {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = TimeZone(secondsFromGMT: 0)

        self.decoder = decoder
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        decoder.dateDecodingStrategy = .formatted(formatter)
    }
    
    public func decode<T: Decodable>(_ message: WebSocketMessage) throws -> T {
        try decoder.decode(T.self, from: message.data)
    }
}
