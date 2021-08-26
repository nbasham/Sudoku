import SwiftUI

class PuzzleIterator: IteratorProtocol {

    private let puzzles: [String]
    @AppStorage("PuzzleIterator_index") private var index: Int = 0

    init() {
        puzzles = Bundle.main.decode([String].self, from: "puzzles.json")
    }

    func next() -> String? {
        defer {
            if index < puzzles.count-1 {
                index += 1
            } else {
                index = 0
            }
        }
        return puzzles[index]
    }
}
