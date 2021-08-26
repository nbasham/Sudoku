import SwiftUI

struct NumberUsageView: View {
    let usage: [Bool]

    var body: some View {
        let columns = [GridItem(.flexible(), spacing: 0), GridItem(.flexible(), spacing: 0), GridItem(.flexible(), spacing: 0)]
        LazyVGrid(columns: columns, alignment: .leading, spacing: 0) {
            ForEach(0...8, id: \.self) { index in
                Rectangle()
                    .stroke(Color.black, lineWidth: 1)
                    .padding(0)
                    .aspectRatio(1, contentMode: .fill)
                    .background(
                        Rectangle()
                            .foregroundColor(usage[index] ? .secondary : .clear)
                    )
            }
        }
        .overlay(
            Rectangle()
                .strokeBorder(Color.black, lineWidth: 1)
        )
        .padding(0)
//        .frame(width: 15)
    }
}

struct NumberUsageView_Previews: PreviewProvider {
    static var previews: some View {
        NumberUsageView(usage: [true, false, true, false, true, false, true, true, true])
    }
}
