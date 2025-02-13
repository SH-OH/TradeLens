import Foundation

public protocol URLSessionProtocol {
    func webSocketTask(with request: URLRequest) -> URLSessionWebSocketTaskProtocol
}

extension URLSession: URLSessionProtocol {
    public func webSocketTask(with request: URLRequest) -> any URLSessionWebSocketTaskProtocol {
        return webSocketTask(with: request) as URLSessionWebSocketTask
    }
}
