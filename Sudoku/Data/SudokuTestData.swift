import Combine

struct SudokuTestData: SudokuDataService {
    let puzzlePublisher = PassthroughSubject<String, Never>()
    private weak var state: SudokuState?
    private var subscriptions = Set<AnyCancellable>()

    init(state: SudokuState) {
        puzzlePublisher
            .map { $0.split(separator: ",")}
            .map { $0.compactMap { Int($0) } }
            .map { $0.map { CellModel(value: $0) } }
            .assign(to: \.cells, on: state)
            .store(in: &subscriptions)
    }

    func next() {
        //  swiftlint:disable:next line_length
        let testPuzzleData = "4,2,1,18,3,5,6,7,8,9,7,17,1,6,4,12,11,5,3,5,15,17,7,11,18,1,13,7,8,3,4,10,18,14,15,2,11,6,13,5,8,7,1,3,9,1,9,5,6,2,12,4,8,16,8,4,7,3,18,10,2,5,15,5,12,2,16,4,15,17,18,10,15,10,9,2,5,17,7,4,12"
        puzzlePublisher.send(testPuzzleData)
    }
}
