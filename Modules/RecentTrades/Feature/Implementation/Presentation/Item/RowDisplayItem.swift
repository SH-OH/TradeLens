import Foundation
import CoreDomain
import SwiftUI

struct RowDisplayItem: Identifiable {
    let id: String
    let price: Double
    let qty: Double
    let timestamp: Date
    let side: Side
    
    var textColor: Color {
        side == .buy ? .green : .red
    }
    
    var formattedTime: String {
        Self.formatter.dateFormat = "HH:mm:ss"
        return Self.formatter.string(from: timestamp)
    }
}

extension RowDisplayItem {
    private static let formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm:ss"
        return formatter
    }()
}
