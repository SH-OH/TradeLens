import Foundation
import CoreNetworkInterface

package enum WebSocketError: Hashable, Error {
    case invalidURL
    case invalidState(WebSocketState)
    case invalidMessage
    case errorFailed
}
