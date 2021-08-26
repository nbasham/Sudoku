import Foundation
import Combine

struct SudokuFileData: SudokuDataService {
    let puzzlePublisher = PassthroughSubject<String, Never>()
    private let iterator = PuzzleIterator()
    private weak var state: SudokuState?
    private var subscriptions = Set<AnyCancellable>()

    init(state: SudokuState) {
        puzzlePublisher
            .map { $0.split(separator: ",") }
            .map { $0.compactMap { Int($0) } }
            .map { $0.map { CellModel(value: $0) } }
            .assign(to: \.cells, on: state)
            .store(in: &subscriptions)
    }

    func next() {
        if let nextPuzzle = iterator.next() {
            puzzlePublisher.send(nextPuzzle)
        }
    }
}
