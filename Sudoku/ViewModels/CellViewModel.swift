import SwiftUI

struct CellViewModel: Identifiable {
    let id: Int
    let text: String
    let color: Color
    let markers: [String]

    init(id: Int, model: CellModel) {
        self.id = id
        self.text = model.markers.isEmpty ? model.text : ""
        color = model.markers.isEmpty ? model.color : Color(UIColor.label)
        if model.markers.isEmpty {
            markers = Array(repeating: "", count: 9)
        } else {
            markers = (0..<9).map { model.markers.contains($0+1) ? "\($0+1)" : "" }
        }
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

extension CellBackground {
    var color: Color {
        var uicolor: UIColor
        switch state {
        case .evenGrid: uicolor = .systemBackground
        case .oddGrid: uicolor = .secondarySystemBackground
        case .selected: uicolor = .systemTeal
        case .highlighted: uicolor = .yellow.withAlphaComponent(0.35)
        case .selectedAndHighlighted: uicolor = .systemTeal
        }
        return Color(uicolor)
    }

    static func calc(cells: [CellViewModel], selectedIndex: Int, selectedNumber: Int?) -> [Color] {
        cells.map {
            let index =  $0.id
            let isHighlighted = $0.text == "\(selectedNumber ?? -1)"
            let isSelected = index == selectedIndex
            return CellBackground(cellIndex: index, isHighlighted: isHighlighted, isSelected: isSelected).color
        }
    }

    static func calc(selectionIndex: Int) -> [Color] {
        (0..<81).map { CellBackground(cellIndex: $0, isSelected: $0==selectionIndex).color }
    }
}
