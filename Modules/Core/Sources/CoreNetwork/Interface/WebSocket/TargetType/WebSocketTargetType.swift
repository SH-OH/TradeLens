import Foundation

public typealias Headers = [String: String]

public protocol WebSocketTargetType: Sendable {
    var baseURL: URL? { get }
    var path: String { get }
    var topics: [String] { get }
    var headers: Headers? { get }
    var errorMap: [Int: Error] { get }
    
    var url: URL? { get }
}

public extension WebSocketTargetType {
    var errorMap: [Int: Error] { [:] }
}
