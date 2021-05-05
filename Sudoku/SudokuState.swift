import Combine

class SudokuState: ObservableObject {
    @Published var selectionIndex: Int = 0
    @Published var cells: [CellModel] = []
    private var subscriptions = Set<AnyCancellable>()
    var selectedCell: CellModel { cells[selectionIndex] }
    var isSolved: Bool { cells.allSatisfy { $0.isCorrect } }

    init() {
        $cells
            .dropFirst() // ignore empty array value from cells declaration
            .sink { o in
                print("cells now has \(o.count) elements.")
                self.selectionIndex = o.firstIndex { cell in
                    cell.isEmpty
                } ?? 0
                print("initial selection set to \(self.selectionIndex).")
            }
            .store(in: &subscriptions)
    }
    
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
//        if selectedCell.markers.contains(number) {
//            selectedCell.markers.remove(number)
//        } else {
//            selectedCell.markers.insert(number)
//        }
//        selectedCell.number = .empty
//        print("cell[\(selectionIndex)] markers \(selectedCell.markers)")
    }
}
