import XCTest
@testable import CoreNetwork
@testable import CoreNetworkInterface
@testable import CoreNetworkTesting

final class WebSocketClientTests: XCTestCase {
    private var sut: WebSocketClient!
    private var session: MockURLSession!
    private var messageCoder: MockWebSocketMessageCoder!
    private var target: MockWebSocketTarget!
    
    override func setUp() {
        session = MockURLSession()
        messageCoder = MockWebSocketMessageCoder()
        target = MockWebSocketTarget()
        sut = WebSocketClient(
            session: session,
            messageCoder: messageCoder
        )
    }
    
    override func tearDown() {
        sut = nil
        session = nil
        messageCoder = nil
        target = nil
        super.tearDown()
    }
    
    // MARK: - Connection Tests
    
    func test_connect_success() async throws {
        // when
        try await sut.connect(target: target)
        
        // then
        XCTAssertTrue(session.mockTask.isResumed)
    }
    
    func test_connect_withInvalidURL_throwsError() async {
        // given
        target = MockWebSocketTarget(baseURL: nil)
        
        // when & then
        do {
            try await sut.connect(target: target)
            XCTFail("Expected error to be thrown")
        } catch {
            XCTAssertEqual(error as? WebSocketError, .invalidURL)
        }
    }
    
    // MARK: - Disconnection Tests
    
    func test_disconnect_success() async throws {
        // given
        try await sut.connect(target: target)
        XCTAssertEqual(session.mockTask.isResumed, true)
        
        // when
        sut.disconnect()
        
        // then
        try await Task.sleep(nanoseconds: 100_000_000)
        XCTAssertTrue(session.mockTask.isCancelled)
        XCTAssertEqual(session.mockTask.closeCode, .normalClosure)
    }
    
    // MARK: - Reconnect Tests
    
    func test_reconnect_attempts_success() async throws {
        // given
        try await sut.connect(target: target)
        session.mockTask.isCancelled = true
        
        // when
        sut.disconnect(reason: "Test Disconnect")
        try await Task.sleep(nanoseconds: 100_000_000)
        try await sut.connect(target: target)
        
        // then
        XCTAssertEqual(session.mockTask.isResumed, true)
    }
    
    func test_reconnect_exceeds_max_attempts() async throws {
        // given
        for i in 1...5 {
            sut.disconnect(reason: "Test Disconnect - \(i)")
        }
        
        // when
        do {
            try await sut.connect(target: target)
        } catch {
            // then
            XCTAssertEqual((error as? WebSocketError), WebSocketError.notConnected)
        }
    }
    
    // MARK: - Message Tests
    
    func test_send_success() async throws {
        // given
        let testMessage = "test message"
        try await sut.connect(target: target)
        messageCoder.valueToReturn = WebSocketMessage(data: Data())
        
        // when
        try await sut.send(testMessage)
        
        // then
        XCTAssertEqual(session.mockTask.messages.count, 1)
    }
    
    func test_receive_success() async throws {
        // given
        try await sut.connect(target: target)
        let expectedMessage = URLSessionWebSocketTask.Message.string("test")
        session.mockTask.messageToReturn = .success(expectedMessage)
        messageCoder.valueToReturn = "test"
        
        // when
        let receivedMessage: String = try await sut.receiveNext()
        
        // then
        XCTAssertEqual(receivedMessage, "test")
    }
    
    func test_messageStream_success() async throws {
        // given
        try await sut.connect(target: target)
        let expectedMessage = URLSessionWebSocketTask.Message.string("test")
        session.mockTask.messageToReturn = .success(expectedMessage)
        messageCoder.valueToReturn = "test"
        
        // when
        guard let stream: AsyncThrowingStream<String, Error> = sut.messageStream(String.self) else {
            XCTFail("Expected stream to be created")
            return
        }
        
        // then
        for try await message in stream {
            XCTAssertEqual(message, "test")
            break
        }
    }
}
