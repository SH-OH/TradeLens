import Foundation
import CoreNetworkInterface

final class MockURLSession: URLSessionProtocol, @unchecked Sendable {
    var mockTask = MockURLSessionWebSocketTask()
    
    func webSocketTask(with request: URLRequest) -> URLSessionWebSocketTaskProtocol {
        return mockTask
    }
}
