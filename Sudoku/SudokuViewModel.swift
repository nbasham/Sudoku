import Foundation
import Combine

class SudokuViewModel: ObservableObject {
    private var state = SudokuState()
    @Published var isSolved: Bool = false
    @Published var selectionIndex: Int = 0
    @Published var cells: [CellViewModel] = []
    let puzzlePublisher = PassthroughSubject<String, Never>()
    let numberPublisher = PassthroughSubject<Int, Never>()
    let markerPublisher = PassthroughSubject<Int, Never>()
    let debugPublisher = PassthroughSubject<Void, Never>()
    private var subscriptions = Set<AnyCancellable>()

    init() {
        state.$selectionIndex
            .assign(to: \.selectionIndex, on: self)
            .store(in: &subscriptions)

        state.$cells
            .map { models in models.enumerated().map {
                $1.markers.isEmpty ?
                CellViewModel(id: $0, model: $1) :
                CellViewModel(id: $0, modelMarkers: $1.markers) }
            }
            .assign(to: \.cells, on: self)
            .store(in: &subscriptions)

        state.$cells
            .dropFirst()
            .filter { $0.isSovled }
            .map { _ in true }
            .assign(to: \.isSolved, on: self)
            .store(in: &subscriptions)

        puzzlePublisher
            .map { $0.split(separator: ",")}
            .map { stringArray in stringArray.compactMap { Int($0) } }
            .map { intArray in intArray.map { ($0 > 9 ? $0-9 : $0, $0 > 9) } }
            .map { tupleArray in tupleArray.map { CellModel(answer: $0.0, isClue: $0.1) } }
            .assign(to: \.cells, on: state)
            .store(in: &subscriptions)

        numberPublisher
            .sink { self.state.setGuess(number: $0) }
            .store(in: &subscriptions)

        markerPublisher
            .sink { self.state.setMarker(number: $0) }
            .store(in: &subscriptions)

        //  Answer all but last cell
        debugPublisher
            .sink {
                let lastEmptyCell = self.state.cells.lastIndex { $0.isEmpty } ?? 79
                for index in 0..<lastEmptyCell {
                    let cell = self.state.cells[index]
                    if !cell.isCorrect {
                        self.state.selectionIndex = index
                        self.state.setGuess(number: cell.answer)
                    }
                }
                self.state.selectionIndex = self.state.cells.firstIndex { $0.isEmpty } ?? 0
            }
            .store(in: &subscriptions)
    }

    func startGame() {
        //  swiftlint:disable:next line_length
        let puzzleData = "4,2,1,18,3,5,6,7,8,9,7,17,1,6,4,12,11,5,3,5,15,17,7,11,18,1,13,7,8,3,4,10,18,14,15,2,11,6,13,5,8,7,1,3,9,1,9,5,6,2,12,4,8,16,8,4,7,3,18,10,2,5,15,5,12,2,16,4,15,17,18,10,15,10,9,2,5,17,7,4,12"

        isSolved = false
        state.selectionIndex = state.cells.firstIndex { $0.isEmpty } ?? 0
        puzzlePublisher.send(puzzleData)
    }

    func select(index: Int) {
        state.selectionIndex = index
    }
}
