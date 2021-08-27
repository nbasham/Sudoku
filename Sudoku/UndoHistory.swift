import Foundation

// http://chris.eidhof.nl/post/undo-history-in-swift/

public struct UndoHistory<A> {
    private let initialValue: A
    private var history: [A] = []
    public var currentItem: A {
        get {
            return history.last ?? initialValue
        }
        set {
            history.append(newValue)
        }
    }

    public init(initialValue: A) {
        self.initialValue = initialValue
    }

    public mutating func undo() {
        guard !history.isEmpty else { return }
        history.removeLast()
    }
}
