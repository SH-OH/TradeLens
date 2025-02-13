import XCTest
import Combine
@testable import OrderBookInterface
@testable import OrderBook
@testable import OrderBookTesting

final class OrderBookUseCaseTests: XCTestCase {
    var mockRepository: MockOrderBookRepository!
    var useCase: OrderBookUseCaseImpl!
    var cancellables: Set<AnyCancellable>!
    
    override func setUp() {
        mockRepository = MockOrderBookRepository()
        useCase = OrderBookUseCaseImpl(repository: mockRepository)
        cancellables = .init()
    }
    
    override func tearDown() {
        mockRepository = nil
        useCase = nil
        cancellables = .init()
    }

    func testObserveOrderBookSuccess() async throws {
        // Given
        mockRepository.mockOrderBooks = [
            OrderBook(
                entries: [OrderBookEntry(id: 1, price: 51816.3, qty: 1709, side: .buy)],
                action: .insert
            )
        ]

        // When
        let expectation = XCTestExpectation(description: #function)
        var result: AccumulatedOrderBook!
        try await useCase.observeOrderBook()
            .sink(receiveCompletion: { completion in
                if case .failure(let error) = completion {
                    XCTFail("Unexpected error: \(error)")
                }
            }, receiveValue: { value in
                result = value
                expectation.fulfill()
            }).store(in: &cancellables)

        await fulfillment(of: [expectation], timeout: 1.0)
        
        // Then
        XCTAssertNotNil(result)
        XCTAssertEqual(result.bids.count, 1)
        XCTAssertEqual(result.bids.first?.entry.price, 51816.3)
    }

    func testObserveOrderBookError() async throws {
        // Given
        mockRepository.mockError = NSError(domain: "TestError: \(#function)", code: -1)

        let useCase = OrderBookUseCaseImpl(repository: mockRepository)

        // When
        var result: Error!
        do {
            let expectation = XCTestExpectation(description: #function)
            try await useCase.observeOrderBook()
                .sink(receiveCompletion: { completion in
                    if case .failure(let error) = completion {
                        result = error
                        expectation.fulfill()
                    }
                }, receiveValue: { value in
                    XCTFail("Expected no values, but received \(value)")
                }).store(in: &cancellables)

            await fulfillment(of: [expectation], timeout: 1.0)
        } catch {
            result = error
        }
        
        // Then
        XCTAssertEqual((result as NSError).domain, "TestError: \(#function)")
    }
}
