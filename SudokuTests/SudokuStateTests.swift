import XCTest
@testable import Sudoku

class SudokuStateTests: XCTestCase {

    var controller: SudokuController!

    override func setUpWithError() throws {
        controller = SudokuController(puzzleSource: TestPuzzleSource())
        UserAction.startGame.send()
    }

    func testStateLoads() throws {
        XCTAssertEqual(81, controller.state.cells.count)
        XCTAssertTrue(controller.state.cells[0].isEmpty)
    }

    func testSetGuess() throws {
        UserAction.cellTouch.send(obj: 0)
        controller.state.setGuess(number: 1)
        XCTAssertFalse(controller.state.cells[0].isEmpty)
        XCTAssertFalse(controller.state.cells[0].isCorrect)
        controller.state.setGuess(number: 4)
        XCTAssertFalse(controller.state.cells[0].isEmpty)
        XCTAssertTrue(controller.state.cells[0].isCorrect)
    }

    func testSetMarker() throws {
        XCTAssertTrue(controller.state.cells[0].markers.isEmpty)
        controller.state.setMarker(number: 1)
        XCTAssertTrue(controller.state.cells[0].markers.contains(1))
        XCTAssertEqual(1, controller.state.cells[0].markers.count)
        controller.state.setMarker(number: 2)
        XCTAssertTrue(controller.state.cells[0].markers.contains(2))
        XCTAssertEqual(2, controller.state.cells[0].markers.count)
        controller.state.setMarker(number: 2)
        XCTAssertFalse(controller.state.cells[0].markers.contains(2))
        XCTAssertEqual(1, controller.state.cells[0].markers.count)
    }

    func testDescription() throws {
        print(controller.state.cells[0].description)
        XCTAssertTrue(controller.state.cells[0].description.contains("answer"))
        XCTAssertTrue(controller.state.cells[0].attribute.description.isEmpty)
        controller.state.selectionIndex = 0
        controller.state.setGuess(number: 1)
        XCTAssertTrue(controller.state.cells[0].attribute.description.contains("guess"))
        XCTAssertTrue(controller.state.cells[3].attribute.description.contains("clue"))
    }

    func testSolved() throws {
        for index in 0..<81 {
            let cell = controller.state.cells[index]
            if cell.isEmpty {
                controller.state.selectionIndex = index
                controller.state.setGuess(number: cell.answer)
            }
        }
        XCTAssertTrue(controller.state.isSolved)
    }
}
