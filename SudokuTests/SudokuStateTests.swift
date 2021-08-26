import XCTest
@testable import Sudoku

class SudokuStateTests: XCTestCase {

    var state: SudokuState!
    var data: SudokuDataService!

    override func setUpWithError() throws {
        state = SudokuState()
        data = SudokuTestData(state: state)
        data.next()
    }

    func testStateLoads() throws {
        XCTAssertEqual(81, state.cells.count)
        XCTAssertTrue(state.cells[0].isEmpty)
    }

    func testSetGuess() throws {
        state.setGuess(number: 1)
        XCTAssertFalse(state.cells[0].isEmpty)
        XCTAssertFalse(state.cells[0].isCorrect)
        state.setGuess(number: 4)
        XCTAssertFalse(state.cells[0].isEmpty)
        XCTAssertTrue(state.cells[0].isCorrect)
    }

    func testSetMarker() throws {
        XCTAssertTrue(state.cells[0].markers.isEmpty)
        state.setMarker(number: 1)
        XCTAssertTrue(state.cells[0].markers.contains(1))
        XCTAssertEqual(1, state.cells[0].markers.count)
        state.setMarker(number: 2)
        XCTAssertTrue(state.cells[0].markers.contains(2))
        XCTAssertEqual(2, state.cells[0].markers.count)
        state.setMarker(number: 2)
        XCTAssertFalse(state.cells[0].markers.contains(2))
        XCTAssertEqual(1, state.cells[0].markers.count)
    }

    func testDescription() throws {
        XCTAssertTrue(state.cells[0].description.contains("answer"))
        XCTAssertTrue(state.cells[0].attribute.description.isEmpty)
        state.selectionIndex = 0
        state.setGuess(number: 1)
        XCTAssertTrue(state.cells[0].attribute.description.contains("guess"))
        XCTAssertTrue(state.cells[3].attribute.description.contains("clue"))
    }

    func testSolved() throws {
        for index in 0..<81 {
            let cell = state.cells[index]
            if cell.isEmpty {
                state.selectionIndex = index
                state.setGuess(number: cell.answer)
            }
        }
        XCTAssertTrue(state.isSolved)
    }
}
