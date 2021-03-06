import Foundation

struct CellBackground {
    internal enum CellBackgroundState { case evenGrid, oddGrid, selected, highlighted, selectedAndHighlighted }
    private let cellIndex: Int
    internal let state: CellBackgroundState

    init(cellIndex: Int, isHighlighted: Bool = false, isSelected: Bool = false) {
        self.cellIndex = cellIndex
        if isHighlighted && isSelected {
            state = .selectedAndHighlighted
        } else if isHighlighted {
            state = .highlighted
        } else if isSelected {
            state = .selected
        } else if CellBackground.isEvenGrid(cellIndex) {
            state = .evenGrid
        } else {
            state = .oddGrid
        }
    }

    private static func isEvenGrid(_ cellIndex: Int) -> Bool {
        for index in 0..<GRIDINDEXES.count {
            if GRIDINDEXES[index].contains(cellIndex) { return index % 2 == 0 }
        }
        fatalError()
    }

    static private let GRIDINDEXES = [
        [0, 1, 2, 9, 10, 11, 18, 19, 20],
        [3, 4, 5, 12, 13, 14, 21, 22, 23],
        [6, 7, 8, 15, 16, 17, 24, 25, 26],
        [27, 28, 29, 36, 37, 38, 45, 46, 47],
        [30, 31, 32, 39, 40, 41, 48, 49, 50],
        [33, 34, 35, 42, 43, 44, 51, 52, 53],
        [54, 55, 56, 63, 64, 65, 72, 73, 74],
        [57, 58, 59, 66, 67, 68, 75, 76, 77],
        [60, 61, 62, 69, 70, 71, 78, 79, 80]
    ]
}

extension CellBackground: CustomStringConvertible {
    var description: String {
        var descriptionString = "\n"
        descriptionString += "background: \(state).\n"
        return descriptionString
    }
}
