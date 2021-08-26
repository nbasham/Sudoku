import XCTest
import SwiftUI
@testable import Sudoku

class SudokuViewModelTests: XCTestCase {

    func testViewModel() throws {
        let viewModel = SudokuViewModel()
        XCTAssertFalse(viewModel.isSolved)
        XCTAssertEqual(0, viewModel.selectionIndex)
        XCTAssertEqual(0, viewModel.cells.count)
        viewModel.data.next()
        XCTAssertEqual(81, viewModel.cells.count)
        viewModel.state.selectionIndex = 1
        XCTAssertEqual(1, viewModel.selectionIndex)
        viewModel.state.setGuess(number: 1)
        XCTAssertEqual("1", viewModel.cells[1].text)
        XCTAssertEqual(Color.red, viewModel.cells[1].color)
        viewModel.state.setGuess(number: 1)
        XCTAssertEqual("", viewModel.cells[1].text)
        viewModel.state.setGuess(number: 2)
        XCTAssertEqual("2", viewModel.cells[1].text)
        viewModel.state.setMarker(number: 1)
        XCTAssertEqual(Color.primary, viewModel.cells[1].color)
        XCTAssertEqual("", viewModel.cells[1].text)
        XCTAssertTrue(viewModel.cells[1].markers.contains("1"))
    }

    func testUI() throws {
        let viewModel = SudokuViewModel()
        viewModel.startGame()
        viewModel.select(index: 0)
        viewModel.numberPublisher.send(1)
        XCTAssertEqual("1", viewModel.cells[0].text)
        viewModel.markerPublisher.send(1)
        XCTAssertEqual("", viewModel.cells[0].text)
        XCTAssertFalse(viewModel.cells[1].markers.isEmpty)
        viewModel.debugPublisher.send()
        XCTAssertEqual("4", viewModel.cells[0].text)
    }
}
