import XCTest
import SwiftUI
@testable import Sudoku

class SudokuViewModelTests: XCTestCase {

    func testViewModel() throws {
        let controller = SudokuController(puzzleSource: TestPuzzleSource())
        let viewModel = controller.viewModel
        XCTAssertFalse(viewModel.isSolved)
        XCTAssertEqual(0, viewModel.selectionIndex)
        XCTAssertEqual(0, viewModel.cells.count)
        UserAction.startGame.send()
        XCTAssertEqual(81, viewModel.cells.count)
        controller.state.selectionIndex = 1
        XCTAssertEqual(1, viewModel.selectionIndex)
        controller.state.setGuess(number: 1)
        XCTAssertEqual("1", viewModel.cells[1].text)
        XCTAssertEqual(Color.red, viewModel.cells[1].color)
        controller.state.setGuess(number: 1)
        XCTAssertEqual("", viewModel.cells[1].text)
        controller.state.setGuess(number: 2)
        XCTAssertEqual("2", viewModel.cells[1].text)
        controller.state.setMarker(number: 1)
//        XCTAssertEqual(Color.primary, viewModel.cells[1].color)
        XCTAssertEqual("", viewModel.cells[1].text)
        XCTAssertTrue(viewModel.cells[1].markers.contains("1"))
    }

    func testUI() throws {
        let controller = SudokuController(puzzleSource: TestPuzzleSource())
        let viewModel = controller.viewModel
        UserAction.startGame.send()
        UserAction.cellTouch.send(obj: 0)
        UserAction.numberTouch.send(obj: 1)
        XCTAssertEqual("1", viewModel.cells[0].text)
        UserAction.markerTouch.send(obj: 1)
        XCTAssertEqual("", viewModel.cells[0].text)
        XCTAssertFalse(viewModel.cells[1].markers.isEmpty)
    }
}
