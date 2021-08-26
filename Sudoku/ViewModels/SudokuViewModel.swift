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
    @Published var usage: [[Bool]] = Array(repeating: Array(repeating: false, count: 9), count: 9)
    let debugPublisher = PassthroughSubject<Void, Never>()
    private var subscriptions = Set<AnyCancellable>()

    func setSelection(index: Int) {
        selectionIndex = index
        calcBackground()
    }

    func setSelectedNumber(_ number: Int) {
        selectedNumber = number == selectedNumber ? nil : number
        calcBackground()
    }

    func setCells(_ cells: [CellViewModel], isSolved: Bool) {
        self.cells = cells
        calcBackground()
        self.isSolved = isSolved
    }

    func startGame(difficutlyLevel: String) {
        isSolved = false
        selectedNumber = nil
        self.difficultyLevel = difficultyLevel
    }

    private func calcBackground() {
        cellBackgroundColors = CellBackground.calc(cells: cells,
                                                   selectedIndex: selectionIndex,
                                                   selectedNumber: selectedNumber)
    }
}
