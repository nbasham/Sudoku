import Combine

class SudokuState: ObservableObject {
    @Published var selectionIndex: Int = 0
    @Published var cells: [CellModel] = []
    private var subscriptions = Set<AnyCancellable>()
    var selectedCell: CellModel { cells[selectionIndex] }
    var isSolved: Bool { cells.allSatisfy { $0.isCorrect } }

    func setGuess(number: Int) {
        var numberState: CellNumberState
        switch selectedCell.number {
            case .empty:
                numberState = .guess(number)
            case .clue:
                fatalError("Cannot set values on clues.")
            case .guess(let n):
                if n == number {
                    numberState = .empty
                } else {
                    numberState = .guess(number)
               }
        }
        cells[selectionIndex] = CellModel(answer: selectedCell.answer, number: numberState)
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
