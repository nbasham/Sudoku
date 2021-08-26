import Foundation
import Combine
import SwiftUI // for color

class SudokuViewModel: ObservableObject {
    internal let state: SudokuState
    internal let data: SudokuDataService
    @Published var isSolved: Bool = false
    @Published var selectionIndex: Int = 0
    @Published var cells: [CellViewModel] = []
    @Published var cellBackgroundColors: [Color] = []
    @Published var difficutlyLevel: String = ""
    @Published var selectedNumber: Int?
    let numberPublisher = PassthroughSubject<Int, Never>()
    let markerPublisher = PassthroughSubject<Int, Never>()
    let debugPublisher = PassthroughSubject<Void, Never>()
    private var subscriptions = Set<AnyCancellable>()

    init(data: SudokuDataService, state: SudokuState) {
        self.data = data
        self.state = state
        subscribeToState()
        subscribeToUIPublishers()
        cellBackgroundColors = CellBackground.calc(selectionIndex: selectionIndex)
        subscribeToCellBackgroundChanges()
    }

    func startGame() {
        // Perhaps startGame should be forwarded to state and the values set below set as a cosequence of that
        isSolved = false
        selectedNumber = nil
        state.selectionIndex = state.cells.firstIndex { $0.isEmpty } ?? 0
        data.next()
        self.difficutlyLevel = state.difficultyLevel
    }

    func select(index: Int) {
        let containsCorrectNumber = !state.cells[index].isEmpty && state.cells[index].isCorrect
        if containsCorrectNumber {
            selectNumber(number: state.cells[index].answer)
        } else {
            state.selectionIndex = index
        }
    }

    private func selectNumber(number: Int) {
        selectedNumber = number == selectedNumber ? nil : number
    }
}

private extension SudokuViewModel {

    func subscribeToCellBackgroundChanges() {
        $selectedNumber
            .filter { _ in !self.cells.isEmpty }
            .map {
                CellBackground.calc(
                    cells: self.cells,
                    selectedIndex: self.selectionIndex,
                    selectedNumber: $0)
            }
            .assign(to: \.cellBackgroundColors, on: self)
            .store(in: &subscriptions)
    }

    func subscribeToUIPublishers() {
        numberPublisher
            .sink { self.state.setGuess(number: $0) }
            .store(in: &subscriptions)

        markerPublisher
            .sink { self.state.setMarker(number: $0) }
            .store(in: &subscriptions)

        //  Answer all but last cell
        debugPublisher
            .sink {
                let lastEmptyCell = self.state.cells.lastIndex { $0.isEmpty } ?? 79
                for index in 0..<lastEmptyCell {
                    let cell = self.state.cells[index]
                    if !cell.isCorrect {
                        self.state.selectionIndex = index
                        self.state.setGuess(number: cell.answer)
                    }
                }
                self.state.selectionIndex = self.state.cells.firstIndex { $0.isEmpty } ?? 0
            }
            .store(in: &subscriptions)
    }

    func subscribeToState() {
        state.$selectionIndex
            .assign(to: \.selectionIndex, on: self)
            .store(in: &subscriptions)

        state.$selectionIndex
            .filter { _ in !self.cells.isEmpty }
            .map {
                CellBackground.calc(
                    cells: self.cells,
                    selectedIndex: $0,
                    selectedNumber: self.selectedNumber)
            }
            .assign(to: \.cellBackgroundColors, on: self)
            .store(in: &subscriptions)

        state.$cells
            .map { models in models.enumerated().map {
                    CellViewModel(id: $0, model: $1)
                }
            }
            .assign(to: \.cells, on: self)
            .store(in: &subscriptions)

        state.$cells
            .dropFirst()
            .filter { $0.isSovled }
            .map { _ in true }
            .assign(to: \.isSolved, on: self)
            .store(in: &subscriptions)
    }
}
