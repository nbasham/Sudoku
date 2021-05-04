import Combine
import SwiftUI

class SudokuViewModel: ObservableObject {
    @Published var state = SudokuState()
    private var subscriptions = Set<AnyCancellable>()
    let puzzlePublisher = PassthroughSubject<String, Never>()
    let numberPublisher = PassthroughSubject<Int, Never>()
    let markerPublisher = PassthroughSubject<Int, Never>()

    init() {
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
    }
    
    func startGame() {
        let puzzleData = "4,2,1,18,3,5,6,7,8,9,7,17,1,6,4,12,11,5,3,5,15,17,7,11,18,1,13,7,8,3,4,10,18,14,15,2,11,6,13,5,8,7,1,3,9,1,9,5,6,2,12,4,8,16,8,4,7,3,18,10,2,5,15,5,12,2,16,4,15,17,18,10,15,10,9,2,5,17,7,4,12"
        puzzlePublisher.send(puzzleData)
    }
}
