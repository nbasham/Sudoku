//
//  SudokuApp.swift
//  Sudoku
//
//  Created by Norman Basham on 5/4/21.
//

import SwiftUI

@main
struct SudokuApp: App {
    @StateObject var controller: SudokuController

    init() {
        let controller = SudokuController(puzzleSource: TestPuzzleSource())
        _controller = StateObject(wrappedValue: controller)
    }

    var body: some Scene {
        WindowGroup {
            NavigationView {
                ContentView()
                    .environmentObject(controller.viewModel)
            }
            .navigationViewStyle(StackNavigationViewStyle())
        }
    }
}
