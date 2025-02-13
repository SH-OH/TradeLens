import Foundation
import Combine
import CoreNetworkInterface
import OSLog

package final actor WebSocketClient: WebSocketServiceProtocol {
    
    private enum Const {
        static let timeout: TimeInterval = 30.0
        static let maxReconnectAttempts: Int = 3
        static let baseReconnectDelay: TimeInterval = 2.0
    }
    
    // MARK: - Properties
    
    private var _state: WebSocketState = .disconnected
    
    private let session: URLSessionProtocol
    private let messageCoder: WebSocketMessageEncoder
    
    private var webSocket: URLSessionWebSocketTaskProtocol?
    private var reconnectAttempts: Int = 0
    private var lastConnectedTarget: WebSocketTargetType?
    
    private let logger: Logger = .init(
        subsystem: "com.SH-OH.TradeLens.Core",
        category: "WebSocketClient"
    )
    
    // MARK: - Initialization
    
    package init(
        session: URLSessionProtocol,
        messageCoder: WebSocketMessageEncoder
    ) {
        self.session = session
        self.messageCoder = messageCoder
    }
    
    deinit {
        disconnect()
    }
    
    // MARK: - Methods
    
    package func validateConnectionState() async throws {
        guard case .connected = _state else {
            logger.warning("⚠️ [WebSocket] 연결되지 않았습니다. 상태: \(String(describing: self._state))")
            throw WebSocketError.invalidState(_state)
        }
    }
    
    package func connect(target: WebSocketTargetType) async throws {
        try await validateAndPrepareConnection(for: target)
        try await establishConnection(with: target)
    }
    
    package nonisolated func disconnect(reason: String? = nil) {
        Task.detached { [weak self] in
            guard let self else { return }
            await self._disconnect(reason: reason)
        }
    }
    
    package func send<T: Encodable & Sendable>(_ value: T) async throws {
        let webSocket = try connectedWebSocket()
        let message = try messageCoder.encode(value)
        
        if let jsonString = String(data: message.data, encoding: .utf8) {
            let wsMessage = URLSessionWebSocketTask.Message.string(jsonString)
            try await webSocket.send(wsMessage)
        } else {
            throw WebSocketError.invalidMessage
        }
    }
    
    package func receiveNext() async throws -> URLSessionWebSocketTask.Message {
        let webSocket = try connectedWebSocket()
        let nextMessage = try await webSocket.receive()
        
        return nextMessage
    }
    
    package nonisolated func messageStream() -> AsyncThrowingStream<URLSessionWebSocketTask.Message, Error> {
        AsyncThrowingStream { continuation in
            Task {
                await createMessageStream(continuation: continuation)
            }
        }
    }
}

// MARK: - Private Methods

extension WebSocketClient {
    
    private func connectedWebSocket() throws -> URLSessionWebSocketTaskProtocol {
        guard let webSocket, _state == .connected else {
            logger.error("❗️ [WebSocket] 연결되지 않음. 상태: \(String(describing: self._state))")
            throw WebSocketError.invalidState(_state)
        }
        return webSocket
    }
    
    private func validateAndPrepareConnection(for target: WebSocketTargetType) async throws {
        guard case .disconnected = _state else {
            throw WebSocketError.invalidState(_state)
        }
        
        guard target.url != nil else {
            throw WebSocketError.invalidURL
        }
        
        _state = .connecting
        lastConnectedTarget = target
    }
    
    private func establishConnection(with target: WebSocketTargetType) async throws {
        var request = URLRequest(url: target.url!)
        
        target.headers?.forEach { key, value in
            request.addValue(value, forHTTPHeaderField: key)
        }
        
        request.timeoutInterval = Const.timeout
        webSocket = session.webSocketTask(with: request)
        webSocket?.resume()
        _state = .connected
    }
    
    private func _disconnect(reason: String? = nil) {
        _state = .disconnecting
        let reasonData = reason?.data(using: .utf8)
        webSocket?.cancel(with: .normalClosure, reason: reasonData)
        webSocket = nil
        _state = .disconnected
        reconnectAttempts = 0
        logger.info("🔍 [WebSocket] 연결 해제됨. 사유: \(reason ?? "nil")")
    }
    
    private func createMessageStream(continuation: AsyncThrowingStream<URLSessionWebSocketTask.Message, Error>.Continuation) async {
        do {
            let webSocket = try connectedWebSocket()
            
            while !Task.isCancelled {
                guard _state == .connected else {
                    throw WebSocketError.invalidState(_state)
                }
                
                let wsMessage = try await webSocket.receive()
                continuation.yield(wsMessage)
            }
            
            logger.debug("🔍 [WebSocket] 메시지 수신 종료")
            continuation.finish()
            
        } catch WebSocketError.invalidState(let state) {
            logger.warning("⚠️ [WebSocket] 연결이 끊어졌습니다. 상태: \(String(describing: state))")
            continuation.finish()
        } catch is CancellationError {
            handleCancellation()
            continuation.finish(throwing: CancellationError())
        } catch {
            logger.error("❌ [WebSocket] 에러 발생: \(error) 상태: \(String(describing: self._state))")
            await handleDisconnection(error: error)
            continuation.finish()
        }
    }
    
    private func handleCancellation() {
        _state = .disconnected
        logger.warning("⚠️ [WebSocket] 작업이 취소되었습니다.")
    }
    
    private func handleDisconnection(error: Error) async {
        _state = .disconnected
        logger.info("⚠️ [WebSocket] 연결이 끊어졌습니다. 재연결(\(String(describing: self.reconnectAttempts))) 시도 중...")
        
        if reconnectAttempts < Const.maxReconnectAttempts {
            reconnectAttempts += 1
            try? await Task.sleep(nanoseconds: calculateReconnectDelay(forAttempt: reconnectAttempts))
            if let lastTarget = lastConnectedTarget {
                try? await connect(target: lastTarget)
            }
        } else {
            logger.error("❌ [WebSocket] 최대 재연결 시도 횟수(\(String(describing: self.reconnectAttempts))/\(String(describing: Const.maxReconnectAttempts)))를 초과했습니다.")
        }
    }
    
    private func calculateReconnectDelay(forAttempt attempt: Int) -> UInt64 {
        let delay = pow(Const.baseReconnectDelay, Double(attempt))
        return UInt64(delay * 1_000_000_000)
    }
}
