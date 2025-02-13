import AppRootInterface
@preconcurrency import Combine
import Foundation
import CoreUtils
import OrderBookInterface

@MainActor
public final class OrderBookViewModel: ObservableObject {
    
    // MARK: - Properties
    
    @Published var bids: [AccumulatedOrderBookEntry] = []
    @Published var asks: [AccumulatedOrderBookEntry] = []
    @Published var isAlertPresented: Bool = false
    @Published var errorMessage: String?
    
    private(set) var bidMaxVolume: Double = 0
    private(set) var askMaxVolume: Double = 0
    
    private let useCase: OrderBookUseCase
    private let webSocketStateCoordinator: WebSocketStateCoordinator
    private var cancellables: AnyCancellables = .init()
    
    // MARK: - Initialization
    
    public nonisolated init(
        useCase: OrderBookUseCase,
        webSocketStateCoordinator: WebSocketStateCoordinator
    ) {
        self.useCase = useCase
        self.webSocketStateCoordinator = webSocketStateCoordinator
        
        Task { @MainActor in
            bind()
        }
    }
    
    func startObserveOrderBook() {
        Task { @MainActor [weak self] in
            guard let self else { return }
            
            do {
                try await useCase.observeOrderBook()
                    .removeDuplicates()
                    .receive(on: DispatchQueue.main)
                    .sink { [weak self] completion in
                        if case .failure(let error) = completion {
                            self?.errorMessage = String(describing: error)
                            self?.isAlertPresented = true
                        }
                    } receiveValue: { [weak self] orderBook in
                        self?.bids = orderBook.bids
                        self?.asks = orderBook.asks
                        
                        self?.bidMaxVolume = orderBook.bidMaxVolume
                        self?.askMaxVolume = orderBook.askMaxVolume
                    }
                    .store(in: &cancellables)
            } catch {
                self.errorMessage = String(describing: error)
                self.isAlertPresented = true
            }
        }
    }
    
    func calculateRowDisplay(
        entry: AccumulatedOrderBookEntry,
        maxVolume: Double
    ) -> RowDisplayItem {
        let volumePercentage = maxVolume > 0
        ? entry.accumulatedVolume / maxVolume
        : 0
        return RowDisplayItem(
            price: entry.entry.price,
            qty: entry.entry.qty.btc,
            volumePercentage: volumePercentage
        )
    }
}

extension OrderBookViewModel {
    
    private func bind() {
        webSocketStateCoordinator.webSocketReadyPublisher
            .filter({ $0 })
            .first()
            .sink { [weak self] _ in
                self?.startObserveOrderBook()
            }.store(in: &cancellables)
    }
}
