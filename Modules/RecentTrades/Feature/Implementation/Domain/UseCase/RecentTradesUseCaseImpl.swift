@preconcurrency import Combine
import OSLog
import RecentTradesInterface

final class RecentTradesUseCaseImpl: RecentTradesUseCase {
    
    private enum Const {
        static let maxEntries: Int = 30
    }
    
    // MARK: - Properties
    
    private let repository: RecentTradesRepository
    private let logger: Logger = .init(
        subsystem: "com.SH-OH.TradeLens.RecentTrades",
        category: "RecentTradesUseCase"
    )
    
    private let cache: RecentTradesCache = .init()
    
    // MARK: - Initialization
    
    init(repository: RecentTradesRepository) {
        self.repository = repository
    }
    
    // MARK: - Methods
    
    func observeRecentTrades() async throws -> AnyPublisher<[RecentTradesEntry], Error> {
        repository.observeRecentTrades()
            .toAnyPublisher()
            .map { [weak self] recentTrades -> [RecentTradesEntry] in
                self?.process(recentTrades) ?? []
            }
            .eraseToAnyPublisher()
    }
}

// MARK: - Private Methods

extension RecentTradesUseCaseImpl {
    
    private func process(_ recentTrades: RecentTrades) -> [RecentTradesEntry] {
        switch recentTrades.action {
        case .partial:
            cache.clear()
            
            let newEntries = cache.entries
                .lazy
                .sorted(by: { $0.timestamp > $1.timestamp })
                .prefix(Const.maxEntries)
                .map({ $0 })
            
            cache.insertEntries(contentsOf: newEntries, at: 0)
            
        case .insert:
            let newEntries = recentTrades.entries
                .sorted(by: { $0.timestamp > $1.timestamp })
            
            cache.insertEntries(contentsOf: newEntries, at: 0)
            
            let updatedEntries = cache.entries
                .prefix(Const.maxEntries)
                .map({ $0 })
            
            cache.updateEntries(newEntries: updatedEntries)
            
        default:
            break
        }
        
        return cache.entries
    }
}
