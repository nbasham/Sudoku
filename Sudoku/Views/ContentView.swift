import SwiftUI

struct ContentView: View {
    @EnvironmentObject var viewModel: SudokuViewModel
    private let boardColumns = Array(repeating: GridItem(.flexible(), spacing: 0), count: 9)
    private let pickerColumns = Array(repeating: GridItem(.flexible(), spacing: 4), count: 3)
    @Environment(\.verticalSizeClass) var sizeClass

    var body: some View {
        VStack {
            usageView()
            boardView
                .padding()
            HStack {
                Spacer()
                VStack {
                    Text("Numbers")
                    numberPicker
                        .frame(width: 152)
                }
                Spacer(minLength: 24)
                VStack {
                    Text("Markers")
                    markerPicker
                        .frame(width: 152)
                }
                Spacer()
            }
            .padding()
        }
        .padding(.horizontal)
        .padding(.horizontal, sizeClass == .compact ? 0 : 64)
        .onAppear {
            UserAction.startGame.send()
        }
        .navigationBarItems(trailing:
                                HStack {
                                    Button("Undo", action: { UserAction.undo.send() })
                                    Button("Debug", action: { UserAction.almostSolve.send() })
                                }
        )
        .navigationTitle(viewModel.difficultyLevel)
        .alert(isPresented: $viewModel.isSolved) {
            Alert(
                title: Text("Congratulations!"),
                message: Text("Would you like to play again?"),
                primaryButton: .default(Text("You bet!"), action: {
                    UserAction.startGame.send()
                }),
                secondaryButton: .cancel()
            )
        }
        .environmentObject(viewModel)
    }

    var boardView: some View {
        LazyVGrid(columns: boardColumns, spacing: 0) {
            ForEach(viewModel.cells, id: \.id) { cell in
                SudokuCellView(cell: cell)
            }
        }
        .overlay(
            ZStack {
                GeometryReader { reader in
                    SudokuGridView(size: reader.size)
                }
                Group {
                    if viewModel.completingLastNumber {
                        Text("Last Number")
                            .font(.system(size: 28, weight: .black, design: .rounded))
                    }
                }
            }
        )
    }

    var numberPicker: some View {
        LazyVGrid(columns: pickerColumns, alignment: .center, spacing: 2) {
            ForEach(1..<10, id: \.self) { index in
                pickerButton(index: index) {
                    UserAction.numberTouch.send(obj: index)
                }
            }
        }
    }

    var markerPicker: some View {
        LazyVGrid(columns: pickerColumns, spacing: 2) {
            ForEach(1..<10, id: \.self) { index in
                pickerButton(index: index) {
                    UserAction.markerTouch.send(obj: index)
                }
            }
        }
    }

    func usageView() -> some View {
        HStack(spacing: 10) {
            ForEach(0...8, id: \.self) { index in
                Button(action: { UserAction.highlightNumber.send(obj: index+1) }, label: {
                    VStack(spacing: 2) {
                        NumberUsageView(usage: viewModel.usage[index])
                        Text("\(index + 1)")
                            .font(.system(size: viewModel.usageViewFontSize, weight: .bold, design: .rounded))
                            .foregroundColor(.secondary)
                    }
                })
            }
        }
        .padding(.horizontal)
    }

    func pickerButton(index: Int, action: @escaping () -> Void) -> some View {
        let len: CGFloat = viewModel.pickerButtonLength
        return Button(action: {
            action()
        }, label: {
            ZStack {
                Color.blue
                    .aspectRatio(1, contentMode: .fit
                    )
                    .mask(
                        RoundedRectangle(cornerRadius: 3)
                    )
            }
            .overlay(
                Text("\(index)")
                    .foregroundColor(.white)
            )
        }
        )
//        .padding(.horizontal, sizeClass == .compact ? 4 : 10)
        .frame(width: len, height: len)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let controller = SudokuController(puzzleSource: TestPuzzleSource())
        UserAction.startGame.send()
        return NavigationView {
            ContentView()
                .environmentObject(controller.viewModel)
        }
        .preferredColorScheme(.dark)
        .navigationViewStyle(StackNavigationViewStyle())
    }
}
