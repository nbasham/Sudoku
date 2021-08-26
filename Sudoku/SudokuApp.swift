//
//  SudokuApp.swift
//  Sudoku
//
//  Created by Norman Basham on 5/4/21.
//

import SwiftUI

@main
struct SudokuApp: App {
    var body: some Scene {
        WindowGroup {
            NavigationView {
                ContentView()
            }
            .navigationViewStyle(StackNavigationViewStyle())
        }
    }
}
