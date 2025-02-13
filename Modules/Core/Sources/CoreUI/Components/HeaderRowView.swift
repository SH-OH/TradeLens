import SwiftUI

public struct HeaderRowView: View {
    private let leadingTitle: String
    private let centerTitle: String
    private let trailingTitle: String
    
    public init(
        leadingTitle: String,
        centerTitle: String,
        trailingTitle: String
    ) {
        self.leadingTitle = leadingTitle
        self.centerTitle = centerTitle
        self.trailingTitle = trailingTitle
    }
    
    public var body: some View {
        HStack {
            Text(leadingTitle)
                .font(.system(size: 12, weight: .bold, design: .monospaced))
                .foregroundStyle(.gray)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            Text(centerTitle)
                .font(.system(size: 12, weight: .bold, design: .monospaced))
                .foregroundStyle(.gray)
                .frame(alignment: .center)
            
            Text(trailingTitle)
                .font(.system(size: 12, weight: .bold, design: .monospaced))
                .foregroundStyle(.gray)
                .frame(maxWidth: .infinity, alignment: .trailing)
        }
        .padding(.horizontal, 16)
        .frame(height: 30)
        .frame(maxWidth: .infinity)
        .background(Color.white)
    }
}

#Preview {
    VStack {
        HeaderRowView(
            leadingTitle: "Price (USD)",
            centerTitle: "Qty",
            trailingTitle: "Time"
        )
        
        Divider()
        
        HeaderRowView(
            leadingTitle: "Qty",
            centerTitle: "Price (USD)",
            trailingTitle: "Qty"
        )
    }
}
