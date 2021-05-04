import Foundation

class CellModel {
    var answer: Int
    var number: CellNumberState
    var markers: Set<Int>
    var isEmpty: Bool { number == .empty }
    var isCorrect: Bool {
        if case .clue = number { return true }
        if case .guess(let number) = number {
            return answer == number
        }
        return false
    }

    init(answer: Int, isClue: Bool) {
        self.answer = answer
        self.number = isClue ? .clue : .empty
        self.markers = []
    }
}

extension CellModel: CustomStringConvertible {
    var description: String {
        var s = "\n"
        s += "answer: \(answer) "
        s += "\(number.description) "
        s += "\(markers.description)"
        s += ""
        return s
    }
}

enum CellNumberState {
    case empty, clue, guess(Int)
}
extension CellNumberState: Equatable {
    static func == (lhs: CellNumberState, rhs: CellNumberState) -> Bool {
        switch (lhs, rhs) {
            case (.empty, .empty):
                return true
            case (.clue, .clue):
                return true
            case let (.guess(_number), .guess(number_)):
                return _number == number_
            default:
                return false
        }
    }
}
extension CellNumberState: CustomStringConvertible {
    var description: String {
        switch self {
            
            case .empty:
                return ""
            case .clue:
                return "clue"
            case let .guess(number):
                return "guess \(number)"
        }
    }
}
