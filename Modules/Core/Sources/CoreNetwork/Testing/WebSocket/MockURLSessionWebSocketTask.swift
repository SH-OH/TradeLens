import Foundation
import CoreNetworkInterface

final class MockURLSessionWebSocketTask: URLSessionWebSocketTaskProtocol, @unchecked Sendable {
    var isResumed = false
    var messages: [URLSessionWebSocketTask.Message] = []
    var isCancelled = false
    var closeCode: URLSessionWebSocketTask.CloseCode?
    var closeReason: Data?
    
    var messageToReturn: Result<URLSessionWebSocketTask.Message, Error>?
    
    func resume() {
        isResumed = true
    }
    
    func send(_ message: URLSessionWebSocketTask.Message) async throws {
        messages.append(message)
    }
    
    func receive() async throws -> URLSessionWebSocketTask.Message {
        guard let messageResult = messageToReturn else {
            throw NSError(domain: "[\(#file)\(#function)] No message", code: -1)
        }
        
        return try messageResult.get()
    }
    
    func cancel(with closeCode: URLSessionWebSocketTask.CloseCode, reason: Data?) {
        isCancelled = true
        self.closeCode = closeCode
        self.closeReason = reason
    }
}
