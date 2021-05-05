import Foundation

extension Array where Element == CellModel {
    var isSovled: Bool { allSatisfy {$0.isCorrect} }
}

struct CellModel {
    var answer: Int
    var attribute: CellAttribute
    var markers: Set<Int>

    init(answer: Int, attribute: CellAttribute) {
        self.answer = answer
        self.attribute = attribute
        self.markers = []
    }

    init(answer: Int, isClue: Bool) {
        self.answer = answer
        self.attribute = isClue ? .clue : .empty
        self.markers = []
    }

    init(answer: Int, markers: Set<Int>) {
        self.answer = answer
        self.attribute = .empty
        self.markers = markers
    }
}

//  Accessors
extension CellModel {
    var isEmpty: Bool { attribute == .empty }
    var isCorrect: Bool {
        switch attribute {
        case .empty: return false
        case .clue: return true
        case .guess(let number): return number == answer
        }
    }
}

extension CellModel: CustomStringConvertible {
    var description: String {
        var descriptionString = "\n"
        descriptionString += "answer: \(answer) "
        descriptionString += "\(attribute.description) "
        descriptionString += "\(markers.description)"
        descriptionString += ""
        return descriptionString
    }
}
