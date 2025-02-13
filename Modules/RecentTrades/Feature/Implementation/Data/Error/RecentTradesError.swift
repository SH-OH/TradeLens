import Foundation

enum RecentTradesError: Error, Sendable {
    case decodingFailed(_ key: Sendable)
}
