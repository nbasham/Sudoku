import SwiftUI

struct CellViewModel: Identifiable {
    let id: Int
    let text: String
    let color: Color
    
    init(_ model: CellModel, index: Int) {
        id = index
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
    }
}
