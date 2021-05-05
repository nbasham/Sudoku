import SwiftUI

struct CellViewModel: Identifiable {
    let id: Int
    let text: String
    let color: Color
    let markers: [String]

    init(id: Int, modelMarkers: Set<Int>) {
        self.id = id
        text = ""
        color = .primary
        markers = (0..<9).map { modelMarkers.contains($0+1) ? "\($0+1)" : "" }
    }

    init(id: Int, model: CellModel) {
        self.id = id
        text = model.text
        color = model.color
        markers = Array(repeating: "", count: 9)
    }
}

private extension CellModel {
    var text: String {
        switch self.attribute {
        case .empty: return ""
        case .clue: return "\(answer)"
        case let .guess(number): return "\(number)"
        }
    }
    var color: Color {
        switch self.attribute {
        case .empty: return .primary
        case .clue: return .blue
        case let .guess(number): return number == answer ? .primary : .red
        }
    }
}
