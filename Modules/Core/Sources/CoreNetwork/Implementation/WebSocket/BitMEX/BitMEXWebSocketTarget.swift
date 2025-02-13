import Foundation
import CoreNetworkInterface

struct BitMEXWebSocketTarget: WebSocketTargetType {
    let symbol: String
    var topics: [String]
    var headers: Headers? { nil }
}

extension BitMEXWebSocketTarget {
    var baseURL: URL? {
        return URL(string: "wss://ws.bitmex.com")
    }
    var path: String { "/realtime" }
    var url: URL? {
        guard let pathUrl = baseURL?.appendingPathComponent(path) else {
            return nil
        }
        
        var components = URLComponents(string: pathUrl.absoluteString)
        
        if !symbol.isEmpty, !topics.isEmpty {
            let values = topics.map({ "\($0):\(symbol)" }).joined(separator: ", ")
            let queryItems = [
                URLQueryItem(name: "subscribe", value: values)
            ]
            components?.queryItems = queryItems
        }
        
        return components?.url
    }
}
