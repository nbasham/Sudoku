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

    let usageViewFontSize: CGFloat = isPad ? 15 : 11
    let pickerButtonLength: CGFloat = isPad ? 44 : 44

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
