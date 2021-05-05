import Combine

class SudokuState: ObservableObject {
    @Published var selectionIndex: Int = 0
    @Published var cells: [CellModel] = []
    private var subscriptions = Set<AnyCancellable>()

    func setGuess(number: Int) {
        var attribute: CellAttribute
        switch selectedCell.attribute {
        case .empty: attribute = .guess(number)
        case .clue: fatalError("Cannot set values on clues.")
        case .guess(let lastGuess): attribute = lastGuess == number ? .empty : .guess(number)
        }
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
}

//  Accessors
extension SudokuState {
    var selectedCell: CellModel { cells[selectionIndex] }
    var isSolved: Bool { cells.allSatisfy { $0.isCorrect } }
}
