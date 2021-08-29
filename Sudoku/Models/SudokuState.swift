import Combine

class SudokuState: ObservableObject {
    ///  Used as a value type for SudokuState, so undo states can be stored in a stack.
    struct SudokuUndoState {
        let selectionIndex: Int
        let cells: [CellModel]
    }

    @Published var selectionIndex: Int = 0
    @Published var cells: [CellModel] = []
    private var subscriptions = Set<AnyCancellable>()

    var undoState: SudokuUndoState {
        SudokuUndoState(selectionIndex: selectionIndex, cells: cells)
    }

    func applyUndoState(_ undoState: SudokuUndoState) {
        selectionIndex = undoState.selectionIndex
        cells = undoState.cells
    }

    func startGame(cells: [CellModel]) {
        self.cells = cells
        selectionIndex = cells.firstIndex { $0.isEmpty } ?? 0
    }

    func setGuess(number: Int) {
        var attribute: CellAttribute
        switch selectedCell.attribute {
        case .empty: attribute = .guess(number)
        case .clue: fatalError("Cannot set values on clues.")
        case .guess(let lastGuess): attribute = lastGuess == number ? .empty : .guess(number)
        }
        removeExistingGuesses(forNumber: number)
        removeMarkersEqualToGuess(guess: number) // THIS should only be applied to grid
        cells[selectionIndex] = CellModel(answer: selectedCell.answer, attribute: attribute)
    }

    func setMarker(number: Int) {
        if selectedCell.markers.contains(number) {
            var markers = selectedCell.markers
            markers.remove(number)
            cells[selectionIndex] = CellModel(answer: selectedCell.answer, markers: markers)
        } else {
            var markers = selectedCell.markers
            markers.insert(number)
            cells[selectionIndex] = CellModel(answer: selectedCell.answer, markers: markers)
        }
    }

    /// After a guess clear guess in the same grid that are the same as the guessed number.
    private func removeExistingGuesses(forNumber number: Int) {
        let gridIndexes = SudokuConstants.gridIndexes(selectionIndex)
        for gridIndex in gridIndexes {
            let gridCell = cells[gridIndex]
            if gridCell.guess == number {
                cells[gridIndex] = CellModel(answer: cells[gridIndex].answer, attribute: .empty)
            }
        }
    }

    /// After a guess clear markers in the same grid/*, row, and or col*/ that are the same as the guessed number.
    private func removeMarkersEqualToGuess(guess number: Int) {
//        let rowColGridIndexes = SudokuConstants.rowColGridIndexes(selectionIndex)
        let indexes = SudokuConstants.gridIndexes(selectionIndex)
        for index in indexes {
            if cells[index].markers.contains(number) {
                cells[index].markers.remove(number)
            }
        }
    }
}

//  Accessors
extension SudokuState {
    var selectedCell: CellModel { cells[selectionIndex] }
    var isSolved: Bool {
        guard !cells.isEmpty else { return false }
        return cells.allSatisfy { $0.isCorrect }
    }
    var clueCount: Int { cells.filter { $0.attribute == .clue }.count }
    var difficultyLevel: String {
        switch clueCount {
        case 27: return "Evil"
        case 30: return "Hard"
        case 33: return "Medium"
        default: return "Easy"
        }
    }
    var lastNumberRemaining: Int? {
        let unansweredIndexes = SudokuConstants.CELLINDEXES.filter { cells[$0].value == nil }
        let firstCellAnswer = cells[unansweredIndexes[0]].answer
        let allTheSame = unansweredIndexes.allSatisfy { firstCellAnswer == cells[$0].answer }
        return allTheSame ? firstCellAnswer : nil
    }
}
