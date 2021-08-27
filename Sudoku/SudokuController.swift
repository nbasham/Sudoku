import Foundation

class SudokuController: ObservableObject {
    struct LastAction {
        let isGuess: Bool
        let value: Int
    }

    internal let state: SudokuState
    private let puzzleSource: PuzzleSource
    private var subscriptions = Set<AnyCancellable>()
    private var lastAction: LastAction?
    @Published var viewModel: SudokuViewModel
    var undoManager: UndoHistory<SudokuState.SudokuUndoState>?

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
        undoManager = UndoHistory(initialValue: state.undoState)
    }

    private func cellTouched(index: Int) {
        let cell = state.cells[index]
        if cell.isCorrect {
            viewModel.setSelectedNumber(cell.answer)
        } else {
            state.selectionIndex = index
        }
    }

    private func numberTouched(number: Int) {
        state.setGuess(number: number)
        lastAction = LastAction(isGuess: true, value: number)
        calcNumbersUsed()
        undoManager?.currentItem = state.undoState
        viewModel.isSolved = state.isSolved
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
        viewModel.usage = usage
    }

    private func markerTouched(number: Int) {
        state.setMarker(number: number)
        lastAction = LastAction(isGuess: false, value: number)
        undoManager?.currentItem = state.undoState
    }

    private func syncViewModelCellsFromState(cells: [CellModel]) {
        let viewModelCells = cells.enumerated().map {
            CellViewModel(id: $0, model: $1, conflicts: markerConflicts)
        }
        viewModel.setCells(viewModelCells)

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

    private func handleCellDoubleTap(index: Int) {
        cellTouched(index: index)
        if let action = lastAction {
            if action.isGuess {
                numberTouched(number: action.value)
            } else {
                markerTouched(number: action.value)
            }
        }
        cellTouched(index: index)
    }

    private func almostSolve() {
        let lastEmptyCell = state.cells.lastIndex { $0.isEmpty } ?? 79
        for index in 0..<lastEmptyCell {
            let cell = state.cells[index]
            if !cell.isCorrect {
                state.selectionIndex = index
                state.setGuess(number: cell.answer)
            }
        }
        state.selectionIndex = state.cells.firstIndex { $0.isEmpty } ?? 0
        calcNumbersUsed()
    }

    private func undo() {
        undoManager?.undo()
        if let item = undoManager?.currentItem {
            state.applyUndoState(item)
            // The applied state may have different conflicts so re-generate cell view models
            syncViewModelCellsFromState(cells: state.cells)
        }
    }
}

import Combine

private extension SudokuController {
    func subscribeToUserActions() {
        let center = NotificationCenter.default

        // start game set state.cells with new puzzle
        center.publisher(for: UserAction.startGame, object: nil)
            .sink { _ in self.startGame() }
            .store(in: &subscriptions)

        // cell touch set state.selectionIndex to new value
        center.publisher(for: UserAction.cellTouch, object: nil)
            .map { $0.asInt() }
            .sink { self.cellTouched(index: $0) }
            .store(in: &subscriptions)

        // cell double tap repeats last action
        center.publisher(for: UserAction.cellDoubleTouch, object: nil)
            .map { $0.asInt() }
            .sink { self.handleCellDoubleTap(index: $0) }
            .store(in: &subscriptions)

        // number pad touch tell state there was a guess
        center.publisher(for: UserAction.numberTouch, object: nil)
            .map { $0.asInt() }
            .sink { self.numberTouched(number: $0) }
            .store(in: &subscriptions)

        // number pad touch tell state to update marker
        center.publisher(for: UserAction.markerTouch, object: nil)
            .map { $0.asInt() }
            .sink { self.markerTouched(number: $0) }
            .store(in: &subscriptions)

        //  Answer all but last cell
        center.publisher(for: UserAction.almostSolve, object: nil)
            .sink { _ in self.almostSolve() }
            .store(in: &subscriptions)

        center.publisher(for: UserAction.undo, object: nil)
            .sink { _ in self.undo() }
            .store(in: &subscriptions)

    }

    func subscribeToStateChanges() {
        state.$selectionIndex
            .sink { self.viewModel.setSelection(index: $0) }
            .store(in: &subscriptions)

        state.$cells
            .sink { cells in self.syncViewModelCellsFromState(cells: cells) }
            .store(in: &subscriptions)
    }
}

class UserAction: ObservableObject {
    let center = NotificationCenter.default
    static let startGame = Notification.Name("ui_startGame")
    static let cellTouch = Notification.Name("ui_celltouch")
    static let cellDoubleTouch = Notification.Name("ui_celldoubletouch")
    static let numberTouch = Notification.Name("ui_numbertouch")
    static let markerTouch = Notification.Name("ui_markertouch")
    static let undo = Notification.Name("ui_undo")
    static let redo = Notification.Name("ui_redo")
    static let almostSolve = Notification.Name("debug_almostsolve")
}
