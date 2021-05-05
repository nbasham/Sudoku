import Combine
import SwiftUI

class SudokuViewModel: ObservableObject {
    private var state = SudokuState()
    @Published var isSolved: Bool = false
    @Published var selectionIndex: Int = 0
    @Published var cells: [CellViewModel] = []
    private var subscriptions = Set<AnyCancellable>()
    let puzzlePublisher = PassthroughSubject<String, Never>()
    let numberPublisher = PassthroughSubject<Int, Never>()
    let markerPublisher = PassthroughSubject<Int, Never>()
    let debugPublisher = PassthroughSubject<Void, Never>()

    init() {
        state.$selectionIndex
            .assign(to: \.selectionIndex, on: self)
            .store(in: &subscriptions)
        
        state.$cells
            .print()
            .map { models in models.enumerated().map { CellViewModel($1, index: $0) } }
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
            .receive(on: RunLoop.main)
            .assign(to: \.cells, on: state)
            .store(in: &subscriptions)
        
        numberPublisher
            .sink { number in
                self.state.setGuess(number: number)
            }
            .store(in: &subscriptions)
        
        markerPublisher
            .sink { number in
                self.state.setMarker(number: number)
            }
            .store(in: &subscriptions)
        
        debugPublisher
            .sink {
                for i in 0...78 {
                    let cell = self.state.cells[i]
                    if !cell.isCorrect {
                        self.state.selectionIndex = i
                        self.state.setGuess(number: cell.answer)
                    }
                }
                self.state.selectionIndex = self.state.cells.firstIndex { $0.isEmpty } ?? 0
            }
            .store(in: &subscriptions)
    }
    
    func startGame() {
        let puzzleData = "4,2,1,18,3,5,6,7,8,9,7,17,1,6,4,12,11,5,3,5,15,17,7,11,18,1,13,7,8,3,4,10,18,14,15,2,11,6,13,5,8,7,1,3,9,1,9,5,6,2,12,4,8,16,8,4,7,3,18,10,2,5,15,5,12,2,16,4,15,17,18,10,15,10,9,2,5,17,7,4,12"
        
        isSolved = false
        selectionIndex = state.cells.firstIndex { $0.isEmpty } ?? 0
        puzzlePublisher.send(puzzleData)
    }
    
    func select(index: Int) {
        state.selectionIndex = index
    }
}
