import CoreNetworkInterface
import Foundation

struct MockWebSocketTarget: WebSocketTargetType {
    var baseURL: URL? = URL(string: "wss://mock.test")
    var path: String = "/test"
    var topics: [String] = ["test"]
    var headers: Headers? = nil
    var url: URL? { baseURL?.appendingPathComponent(path) }
}
