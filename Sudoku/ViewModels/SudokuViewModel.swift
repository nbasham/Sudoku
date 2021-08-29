import Foundation
import Combine
import SwiftUI // for color

class SudokuViewModel: ObservableObject {
    @Published var isSolved: Bool = false
    @Published var selectionIndex: Int = 0
    @Published var cells: [CellViewModel] = []
    @Published var cellBackgroundColors: [Color] = CellBackground.initial
    @Published var difficultyLevel: String = ""
    @Published var selectedNumber: Int?
    @Published var completingLastNumber: Bool = false
    @Published var usage: [[Bool]] = Array(repeating: Array(repeating: false, count: 9), count: 9)
    let debugPublisher = PassthroughSubject<Void, Never>()
    private var subscriptions = Set<AnyCancellable>()

    var useColor = false
    let usageViewFontSize: CGFloat = isPad ? 15 : 11
    let pickerButtonLength: CGFloat = isPad ? 44 : 44

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

    func setSelection(index: Int) {
        selectionIndex = index
        calcBackground()
    }

    func setSelectedNumber(_ number: Int) {
        selectedNumber = number == selectedNumber ? nil : number
        calcBackground()
    }

    func setCells(_ cells: [CellViewModel]) {
        self.cells = cells
        calcBackground()
    }

    func startGame(difficutlyLevel: String) {
        isSolved = false
        selectedNumber = nil
        self.difficultyLevel = difficultyLevel
        self.completingLastNumber = false
    }

    private func calcBackground() {
        cellBackgroundColors = CellBackground.calc(cells: cells,
                                                   selectedIndex: selectionIndex,
                                                   selectedNumber: selectedNumber)
    }
}
