import SwiftUI

struct CellViewModel: Identifiable {
    let id: Int
    let text: String
    let color: Color
    let markers: [String]
    
    init(_ model: CellModel, index: Int) {
        id = index
        if model.markers.isEmpty {
            markers = Array(repeating: "", count: 9)
            switch model.number {
                case .empty:
                    text = ""
                    color = .primary
                case .clue:
                    text = "\(model.answer)"
                    color = .blue
                case .guess(let number):
                    text = "\(number)"
                    color = number == model.answer ? .primary : .red
            }
        } else {
            text = ""
            color = .primary
            var a = Array(repeating: "", count: 9)
            for i in 1...9 {
                if model.markers.contains(i) {
                    a[i-1] = "\(i)"
                }
            }
            markers = a
        }
    }
}
