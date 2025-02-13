import Foundation

public enum MessageAction: String, Sendable {
    case partial
    case update
    case delete
    case insert
}
