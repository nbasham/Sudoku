import Foundation

enum CellAttribute {
    case empty, clue, guess(Int)
}

extension CellAttribute: Equatable {
    static func == (lhs: CellAttribute, rhs: CellAttribute) -> Bool {
        switch (lhs, rhs) {
        case (.empty, .empty): return true
        case (.clue, .clue): return true
        case let (.guess(lhsnumber), .guess(rhsnumber)): return lhsnumber == rhsnumber
        default: return false
        }
    }
}

extension CellAttribute: CustomStringConvertible {
    var description: String {
        switch self {
        case .empty: return ""
        case .clue: return "clue"
        case let .guess(number): return "guess \(number)"
        }
    }
}
