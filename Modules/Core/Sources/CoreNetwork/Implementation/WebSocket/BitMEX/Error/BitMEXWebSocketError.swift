import Foundation

public enum BitMEXWebSocketError: Error {
    case invalidMessage
    case subscriptionFailed
    case unsubscriptionFailed
    case errorFailed
    case skipMessage
    case subscriptionCancelled(unsubscribe: String)
    case unknown
}
