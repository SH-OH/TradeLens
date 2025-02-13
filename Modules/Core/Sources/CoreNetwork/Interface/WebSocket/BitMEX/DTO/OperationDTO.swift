import Foundation

public struct OperationDTO: Codable, Sendable {
    public let op: String
    public let args: [String]
    
    public init(op: String, args: [String]) {
        self.op = op
        self.args = args
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        op = try container.decode(String.self, forKey: .op)
        
        if let arg = try? container.decode(String.self, forKey: .args) {
            args = [arg]
        } else {
            args = try container.decode([String].self, forKey: .args)
        }
    }
}
