import Foundation
import CoreNetworkInterface

package actor BitMEXWebSocketRepositoryImpl: BitMEXWebSocketRepository {
    
    private let webSocketClient: WebSocketServiceProtocol
    private let messageCoder: WebSocketMessageDecoder
    
    package init(
        webSocketClient: WebSocketServiceProtocol,
        messageCoder: WebSocketMessageDecoder
    ) {
        self.webSocketClient = webSocketClient
        self.messageCoder = messageCoder
    }
    
    package func connect() async throws {
        let target = BitMEXWebSocketTarget(symbol: "", topics: [])
        try await webSocketClient.connect(target: target)
    }
    
    package func subscribe(symbol: String, topics: String...) async throws {
        try await webSocketClient.validateConnectionState()
        
        let args = topics.map({ "\($0):\(symbol)" })
        let subscription = OperationDTO(
            op: "subscribe",
            args: args
        )
        try await webSocketClient.send(subscription)
    }
    
    package func unsubscribe(symbol: String, topics: String...) async throws {
        let args = topics.map({ "\($0):\(symbol)" })
        let unsubscription = OperationDTO(
            op: "unsubscribe",
            args: args
        )
        try await webSocketClient.send(unsubscription)
    }
    
    package func disconnect() async {
        webSocketClient.disconnect(reason: nil)
    }
    
    package nonisolated func messageStream<T: Decodable & Sendable>(_ type: T.Type) -> AsyncThrowingStream<T, Error> {
        AsyncThrowingStream { continuation in
            Task {
                await createMessageStream(continuation: continuation)
            }
        }
    }
}

// MARK: - Private Methods

extension BitMEXWebSocketRepositoryImpl {
    
    private func createMessageStream<T: Decodable & Sendable>(continuation: AsyncThrowingStream<T, Error>.Continuation) async {
        let stream = webSocketClient.messageStream()
        
        do {
            for try await wsMessage in stream {
                do {
                    guard let decodedValue: T = try await decodeMessage(wsMessage) else {
                        continue
                    }
                    
                    continuation.yield(decodedValue)
                } catch BitMEXWebSocketError.skipMessage {
                    continue
                }
            }
        } catch {
            continuation.finish(throwing: error)
        }
    }
    
    private func decodeMessage<T: Decodable & Sendable>(_ wsMessage: URLSessionWebSocketTask.Message) async throws -> T {
        let message = try convertToWebSocketMessage(wsMessage)
        
        // 웰컴 메시지 처리 및 메시지 무시
        if (try? handleWelcomeMessage(message)) != nil {
            throw BitMEXWebSocketError.skipMessage
        }
        
        // 구독 메시지 처리 및 메시지 무시
        if (try? handleSubscriptionResponse(message)) != nil {
            throw BitMEXWebSocketError.skipMessage
        }
        
        // 구독 해제 메시지 처리
        if let unsubscription = try? handleUnsubscriptionResponse(message) {
            throw BitMEXWebSocketError.subscriptionCancelled(unsubscribe: unsubscription.unsubscribe)
        }
        
        // BitMEX 메시지 체크
        if let bitMEXError = try? handleBitMEXError(message) {
            throw bitMEXError
        }
        
        // 일반적인 메시지 처리
        do {
            return try messageCoder.decode(message)
        } catch {
            throw BitMEXWebSocketError.skipMessage
        }
    }
    
    private func convertToWebSocketMessage(_ wsMessage: URLSessionWebSocketTask.Message) throws -> WebSocketMessage {
        let wsMessageData: Data
        
        switch wsMessage {
        case .data(let data):
            wsMessageData = data
        case .string(let string):
            guard let data = string.data(using: .utf8) else {
                throw BitMEXWebSocketError.invalidMessage
            }
            wsMessageData = data
        @unknown default:
            throw BitMEXWebSocketError.unknown
        }
        
        return WebSocketMessage(data: wsMessageData)
    }
    
    private func handleWelcomeMessage(_ message: WebSocketMessage) throws -> WebSocketWelcomeDTO {
        try messageCoder.decode(message)
    }
    
    private func handleSubscriptionResponse(_ message: WebSocketMessage) throws -> SubscriptionResponseDTO {
        let response: SubscriptionResponseDTO = try messageCoder.decode(message)
        
        guard response.success else {
            throw BitMEXWebSocketError.subscriptionFailed
        }
        
        return response
    }
    
    private func handleUnsubscriptionResponse(_ message: WebSocketMessage) throws -> UnsubscriptionResponseDTO {
        let response: UnsubscriptionResponseDTO = try messageCoder.decode(message)
        
        guard response.success else {
            throw BitMEXWebSocketError.unsubscriptionFailed
        }
        
        return response
    }
    
    private func handleBitMEXError(_ message: WebSocketMessage) throws -> BitMEXErrorDTO {
        let response: BitMEXErrorDTO = try messageCoder.decode(message)
        
        guard !response.error.isEmpty else {
            throw BitMEXWebSocketError.errorFailed
        }
        
        return response
    }
}
