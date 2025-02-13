import AppRootInterface
@preconcurrency import Combine
import CoreUtils
import Foundation
import RecentTradesInterface

@MainActor
public final class RecentTradesViewModel: ObservableObject {
    
    // MARK: - Properties
    
    @Published var entries: [RecentTradesEntry] = []
    @Published var isAlertPresented: Bool = false
    @Published var errorMessage: String?
    @Published private(set) var animatedRows: Set<String> = .init()
    
    private let useCase: RecentTradesUseCase
    private let webSocketStateCoordinator: WebSocketStateCoordinator
    private var cancellables: AnyCancellables = .init()
    
    // MARK: - Initialization
    
    public nonisolated init(
        useCase: RecentTradesUseCase,
        webSocketStateCoordinator: WebSocketStateCoordinator
    ) {
        self.useCase = useCase
        self.webSocketStateCoordinator = webSocketStateCoordinator
        
        Task { @MainActor in
            bind()
        }
    }
    
    func startObserveRecentTrades() {
        Task { @MainActor in
            do {
                try await useCase.observeRecentTrades()
                    .removeDuplicates()
                    .receive(on: DispatchQueue.main)
                    .sink { [weak self] completion in
                        if case .failure(let error) = completion {
                            self?.errorMessage = String(describing: error)
                            self?.isAlertPresented = true
                        }
                    } receiveValue: { [weak self] entries in
                        self?.entries = entries
                    }.store(in: &cancellables)
            } catch {
                self.errorMessage = String(describing: error)
                self.isAlertPresented = true
            }
        }
    }
    
    func calculateRowDisplay(entry: RecentTradesEntry) -> RowDisplayItem {
        RowDisplayItem(
            id: entry.id,
            price: entry.price,
            qty: entry.qty.btc,
            timestamp: entry.timestamp,
            side: entry.side
        )
    }
    
    func animated(_ id: String) {
        animatedRows.insert(id)
    }
    
    func hasAniamted(_ id: String) -> Bool {
        animatedRows.contains(id)
    }
}

extension RecentTradesViewModel {
    
    private func bind() {
        webSocketStateCoordinator.webSocketReadyPublisher
            .filter({ $0 })
            .first()
            .sink { [weak self] _ in
                self?.startObserveRecentTrades()
            }.store(in: &cancellables)
    }
}
