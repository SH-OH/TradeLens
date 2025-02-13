import Foundation

enum OrderBookError: Error, Sendable {
    case decodingFailed(_ key: Sendable)
}
