import Foundation

class SudokuController: ObservableObject {
    internal let state: SudokuState
    private let puzzleSource: PuzzleSource
    private var subscriptions = Set<AnyCancellable>()
    @Published var viewModel: SudokuViewModel

    init(puzzleSource: PuzzleSource = FilePuzzleSource()) {
        self.puzzleSource = puzzleSource
        state = SudokuState()
        viewModel = SudokuViewModel()
        subscribeToUserActions()
        subscribeToStateChanges()
    }

    private func startGame() {
        let cells = puzzleSource.next()
        state.startGame(cells: cells)
        viewModel.startGame(difficutlyLevel: self.state.difficultyLevel)
        calcNumbersUsed()
    }

    private func cellTouched(index: Int) {
        let cell = state.cells[index]
        if cell.isCorrect {
            viewModel.setSelectedNumber(cell.answer)
        } else {
            print("state.selectionIndex \(index)")
            state.selectionIndex = index
        }
    }

    private func numberTouched(number: Int) {
        state.setGuess(number: number)
        calcNumbersUsed()
    }

    private func calcNumbersUsed() {
        var usage = Array(repeating: Array(repeating: false, count: 9), count: 9)
        var index = 0
        for cell in state.cells {
            if let value = cell.value {
                let gridIndex = SudokuConstants.indexToGrid(index)
                usage[value-1][gridIndex] = true
            }
            index += 1
        }
//        viewModel.objectWillChange.send()
        viewModel.usage = usage
    }

    private func markerTouched(number: Int) {
        state.setMarker(number: number)
    }
}

import Combine

private extension SudokuController {
    func subscribeToUserActions() {
        let center = NotificationCenter.default

        // start game set state.cells with new puzzle
        center.publisher(for: UserAction.startGame, object: nil)
            .sink { _ in
                self.startGame()
            }
            .store(in: &subscriptions)

        // cell touch set state.selectionIndex to new value
        center.publisher(for: UserAction.cellTouch, object: nil)
            // swiftlint:disable force_cast
            .map({ ($0.object as! NSNumber).intValue })
            .sink {
                self.cellTouched(index: $0)
            }
            .store(in: &subscriptions)

        // number pad touch tell state there was a guess
        center.publisher(for: UserAction.numberTouch, object: nil)
            // swiftlint:disable force_cast
            .map({ ($0.object as! NSNumber).intValue })
            .sink { self.numberTouched(number: $0) }
            .store(in: &subscriptions)

        // number pad touch tell state to update marker
        center.publisher(for: UserAction.markerTouch, object: nil)
            // swiftlint:disable force_cast
            .map({ ($0.object as! NSNumber).intValue })
            .sink { self.markerTouched(number: $0) }
            .store(in: &subscriptions)

        //  Answer all but last cell
        center.publisher(for: UserAction.almostSolve, object: nil)
            .sink { _ in
                let lastEmptyCell = self.state.cells.lastIndex { $0.isEmpty } ?? 79
                for index in 0..<lastEmptyCell {
                    let cell = self.state.cells[index]
                    if !cell.isCorrect {
                        self.state.selectionIndex = index
                        self.state.setGuess(number: cell.answer)
                    }
                }
                self.state.selectionIndex = self.state.cells.firstIndex { $0.isEmpty } ?? 0
                self.calcNumbersUsed()
            }
            .store(in: &subscriptions)
    }

    func subscribeToStateChanges() {
        state.$selectionIndex
            //            .filter { _ in !self.cells.isEmpty }
            .sink {
                print("viewModel.selectionIndex \($0)")
                self.viewModel.setSelection(index: $0)
            }
            .store(in: &subscriptions)

        state.$cells
            .map { models in models.enumerated().map {
                CellViewModel(id: $0, model: $1, conflicts: self.markerConflicts)
            }
            }
            .sink {
                self.viewModel.setCells($0, isSolved: self.state.isSolved)
            }
            .store(in: &subscriptions)
    }
    func markerConflicts(_ cellIndex: Int, markerValue: Int) -> Bool {
            for indexes in [SudokuConstants.rowIndexes(cellIndex),
                            SudokuConstants.colIndexes(cellIndex),
                            SudokuConstants.gridIndexes(cellIndex)] {
                let unique = indexes.filter { $0 != cellIndex }.allSatisfy { state.cells[$0].value != markerValue }
                if unique == false {
                    return true
                }
            }
        return false
    }
}

class UserAction: ObservableObject {
    let center = NotificationCenter.default
    static let startGame = Notification.Name("ui_startGame")
    static let cellTouch = Notification.Name("ui_celltouch")
    static let numberTouch = Notification.Name("ui_numbertouch")
    static let markerTouch = Notification.Name("ui_markertouch")
    static let almostSolve = Notification.Name("debug_almostsolve")
}
