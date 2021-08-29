import SwiftUI

struct ColorSymbolViewModel {
    let color: Color
    let markerColors: [Color]
    let markerConflicts: [Bool]

    init(cellIndex: Int, model: CellModel, conflicts: (Int, Int) -> Bool) {
        self.color = colorForNumber(model.answer)

        var tempMarkerColors = Array(repeating: Color.clear, count: 9)
        for marker in model.markers {
            tempMarkerColors[marker-1] = colorForNumber(marker)
        }
        self.markerColors = tempMarkerColors

        var tempMarkerConflicts = Array(repeating: false, count: 9)
        for marker in model.markers {
            tempMarkerConflicts[marker-1] = conflicts(cellIndex, marker)
        }
        self.markerConflicts = tempMarkerConflicts

        func colorForNumber(_ number: Int) -> Color {
            [Color(hex: "D62469"),
             Color(hex: "F87F1F"),
             Color(hex: "F9C71E"),
             Color(hex: "AFCE3B"),
             Color(hex: "187349"),
             Color(hex: "00ABED"),
             Color(hex: "0665AE"),
             Color(hex: "64095E"),
             Color(hex: "000000")][number - 1]
        }
    }
}

struct TextSymbolViewModel {
    let text: String
    let fontSize: CGFloat
    let fontWeight: Font.Weight
    let color: Color
    let markers: [String]
    let markerConflicts: [Bool]

    init(cellIndex: Int, model: CellModel, conflicts: (Int, Int) -> Bool) {
        self.text = model.markers.isEmpty ? model.text : ""
        self.fontSize = isPad ? 23 : 15
        self.fontWeight = model.fontWeight
        color = model.markers.isEmpty ? model.color : Color(UIColor.label)
        if model.markers.isEmpty {
            markers = Array(repeating: "", count: 9)
            markerConflicts = Array(repeating: false, count: 9)
        } else {
            markers = (0..<9).map { model.markers.contains($0+1) ? "\($0+1)" : "" }
            var tempMarkerConflicts = Array(repeating: false, count: 9)
            markers.filter { $0 != "" }.forEach { marker in
                let markerInt = Int(marker)!
                tempMarkerConflicts[markerInt - 1] = conflicts(cellIndex, markerInt)
            }
            markerConflicts = tempMarkerConflicts
        }
    }
}

struct CellViewModel: Identifiable {
    let id: Int
    let textSymbol: TextSymbolViewModel
    let colorSymbol: ColorSymbolViewModel

    init(id: Int, model: CellModel, conflicts: (Int, Int) -> Bool) {
        self.id = id
        self.textSymbol = TextSymbolViewModel(cellIndex: id, model: model, conflicts: conflicts)
        self.colorSymbol = ColorSymbolViewModel(cellIndex: id, model: model, conflicts: conflicts)
    }
}

/// Helpers for building view model.
private extension CellModel {
    var text: String {
        switch self.attribute {
        case .empty: return ""
        case .clue: return "\(answer)"
        case let .guess(number): return "\(number)"
        }
    }
    var fontWeight: Font.Weight {
        switch self.attribute {
        case .empty: return .regular
        case .clue: return .medium
        case .guess(_): return .regular
        }
    }
    var color: Color {
        switch self.attribute {
        case .empty: return .primary
        case .clue: return .primary
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
        guard !cells.isEmpty else { return initial }
        return cells.map {
            let index =  $0.id
            let isHighlighted = $0.textSymbol.text == "\(selectedNumber ?? -1)"
            let isSelected = index == selectedIndex
            return CellBackground(cellIndex: index, isHighlighted: isHighlighted, isSelected: isSelected).color
        }
    }

    static var initial: [Color] {
        Array(repeating: .white, count: 81)
    }
}
