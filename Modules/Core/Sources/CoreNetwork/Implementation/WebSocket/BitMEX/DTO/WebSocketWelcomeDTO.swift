import Foundation

struct WebSocketWelcomeDTO: Decodable {
    let info: String
    let version: String
    let heartbeatEnabled: Bool
}
