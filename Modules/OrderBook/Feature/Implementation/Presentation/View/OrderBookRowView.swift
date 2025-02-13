import CoreUI
import SwiftUI

struct OrderBookRowView: View {
    let displayData: RowDisplayItem
    let textColor: Color
    let isBid: Bool
    
    var body: some View {
        HStack(spacing: 0) {
            if isBid {
                qtyText
                priceText
            } else {
                priceText
                qtyText
            }
        }
        .frame(height: 40)
        .frame(maxWidth: .infinity)
        .background(volumeBackground)
    }
    
    private var priceText: some View {
        Text(String(format: "%.1f", displayData.price))
            .font(.system(size: 13, weight: .bold, design: .monospaced))
            .foregroundStyle(textColor)
            .frame(maxWidth: .infinity, alignment: isBid ? .trailing : .leading)
            .padding(.horizontal, 8)
    }
    
    private var qtyText: some View {
        Text(String(format: "%.4f", displayData.qty))
            .font(.system(size: 13, weight: .medium, design: .monospaced))
            .foregroundColor(.black)
            .frame(alignment: isBid ? .leading : .trailing)
            .padding(isBid ? .leading : .trailing, 16)
    }
    
    private var volumeBackground: some View {
        GeometryReader { geometry in
            Rectangle()
                .fill(textColor.opacity(0.1))
                .frame(width: max(0, geometry.size.width * displayData.volumePercentage))
                .offset(
                    x: isBid
                    ? max(0, geometry.size.width * (1 - displayData.volumePercentage))
                    : 0
                )
        }
        .background(Color.white)
    }
}

#Preview {
   VStack(spacing: 1) {
       OrderBookRowView(
           displayData: RowDisplayItem(
               price: 51816.3,
               qty: 0.1709,
               volumePercentage: 0.2
           ),
           textColor: .green,
           isBid: true
       )
       
       OrderBookRowView(
           displayData: RowDisplayItem(
               price: 51816.0,
               qty: 0.3232,
               volumePercentage: 0.5
           ),
           textColor: .green,
           isBid: true
       )
       
       OrderBookRowView(
           displayData: RowDisplayItem(
               price: 51815.9,
               qty: 0.7068,
               volumePercentage: 1.0
           ),
           textColor: .green,
           isBid: true
       )
   }
   .background(Color.cyan)
}

#Preview("Ask Orders") {
   VStack(spacing: 1) {
       OrderBookRowView(
           displayData: RowDisplayItem(
               price: 51816.4,
               qty: 3.8930,
               volumePercentage: 0.8
           ),
           textColor: .red,
           isBid: false
       )
       
       OrderBookRowView(
           displayData: RowDisplayItem(
               price: 51816.9,
               qty: 1.3259,
               volumePercentage: 0.5
           ),
           textColor: .red,
           isBid: false
       )
       
       OrderBookRowView(
           displayData: RowDisplayItem(
               price: 51818.9,
               qty: 0.0463,
               volumePercentage: 0.2
           ),
           textColor: .red,
           isBid: false
       )
   }
   .background(Color.cyan)
}
