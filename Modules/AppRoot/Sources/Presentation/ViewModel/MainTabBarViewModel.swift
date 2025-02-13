import AppRootInterface
import Combine
import Foundation
import OrderBook
import RecentTrades

public class MainTabBarViewModel: ObservableObject, @unchecked Sendable {
    @Published var isAlertPresented: Bool = false
    @Published var errorMessage: String?
    
    @Published private(set) var selectedTab: MainTab
    
    private let readySubject: PassthroughSubject<Bool, Never> = .init()
    
    private let webSocketManagementUseCase: WebSocketManagementUseCase
    
    public init(
        selectedTab: MainTab,
        webSocketManagementUseCase: WebSocketManagementUseCase
    ) {
        self.selectedTab = selectedTab
        self.webSocketManagementUseCase = webSocketManagementUseCase
    }
    
    @MainActor
    func selectTab(_ tab: MainTab) {
        selectedTab = tab
    }
    
    func connectWebSocket() async {
        do {
            try await webSocketManagementUseCase.connect()
            try await webSocketManagementUseCase.subscribeAll()
            
            await MainActor.run(body: {
                readySubject.send(true)
            })
        } catch {
            await MainActor.run(body: {
                readySubject.send(false)
            })
        }
    }
}

extension MainTabBarViewModel: WebSocketStateCoordinator {
    public var webSocketReadyPublisher: AnyPublisher<Bool, Never> {
        readySubject.eraseToAnyPublisher()
    }
}
