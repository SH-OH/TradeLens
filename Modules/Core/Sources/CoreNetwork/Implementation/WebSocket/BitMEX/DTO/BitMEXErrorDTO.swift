import Foundation

struct BitMEXErrorDTO: Error, Decodable {
    let error: String
}
