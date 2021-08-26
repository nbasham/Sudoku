import Foundation

extension Array where Element == CellModel {
    var isSovled: Bool { allSatisfy {$0.isCorrect} }
}

struct CellModel {
    var answer: Int
    var attribute: CellAttribute
    var markers: Set<Int>

    /// Used when loading from data/file
    init(value: Int) {
        if value > 9 {
            self.answer = value - 9
            self.attribute = .clue
        } else {
            self.answer = value
            self.attribute = .empty
        }
        self.markers = []
    }

    /// Used when setting or clearing a guess
    init(answer: Int, attribute: CellAttribute) {
        self.answer = answer
        self.attribute = attribute
        self.markers = []
    }

    /// Used when setting or clearing markers
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
    var guess: Int? {
        switch attribute {
        case .guess(let number): return number
        case .empty: return nil
        case .clue: return nil
        }
    }
    var value: Int? {
        switch attribute {
        case .guess(let number): return number
        case .empty: return nil
        case .clue: return answer
        }
    }
}

extension CellModel: ExpressibleByStringLiteral {
    /// Currently not used
    public init(stringLiteral value: String) {
        guard let intValue = Int(value) else { fatalError() }
        self = CellModel(value: intValue)
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
