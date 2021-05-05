import SwiftUI

struct ContentView: View {
    @StateObject var viewModel: SudokuViewModel
    private let boardColumns = Array(repeating: GridItem(.flexible(), spacing: 0), count: 9)
    private let pickerColumns = Array(repeating: GridItem(.flexible(), spacing: 4), count: 3)
    private let markerColumns = Array(repeating: GridItem(.flexible(), spacing: 0), count: 3)
    @Environment(\.verticalSizeClass) var sizeClass

    init() {
        let viewModel = SudokuViewModel()
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        VStack {
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
        .padding()
        .onAppear {
            viewModel.startGame()
        }
        .navigationBarItems(trailing: Button("Debug", action: viewModel.debugPublisher.send))
        .alert(isPresented: $viewModel.isSolved) {
            Alert(
                title: Text("Congratulations!"),
                message: Text("Would you like to play again?"),
                primaryButton: .default(Text("You bet!"), action: {
                    viewModel.startGame()
                }),
                secondaryButton: .cancel()
            )
        }
    }

    var boardView: some View {
        LazyVGrid(columns: boardColumns, spacing: 0) {
            ForEach(viewModel.cells, id: \.id) { cell in
                Rectangle()
                    .stroke()
                    .aspectRatio(1, contentMode: .fill)
                    .overlay(
                        Text("\(cell.text)")
                            .foregroundColor(cell.color)
                    )
                    .overlay(
                        markersView(cell: cell)
                    )
                    .background(
                        viewModel.selectionIndex == cell.id ? Color.green : .white
                    )
                    .onTapGesture {
                        viewModel.select(index: cell.id)
                    }
            }
        }
    }

    func markersView(cell: CellViewModel) -> some View {
        LazyVGrid(columns: markerColumns, spacing: sizeClass == .compact ? 0 : 4) {
                ForEach(0..<9, id: \.self) { index in
                    Text(cell.markers[index])
                        .font(.system(size: sizeClass == .compact ? 3 : 16, design: .monospaced))
                        .minimumScaleFactor(0.1)
                }
            }
        .fixedSize()
    }

    var numberPicker: some View {
        LazyVGrid(columns: pickerColumns, alignment: .center, spacing: 2) {
            ForEach(1..<10, id: \.self) { index in
                pickerButton(index: index) {
                    viewModel.numberPublisher.send(index)
                }
            }
        }
    }

    var markerPicker: some View {
        LazyVGrid(columns: pickerColumns, spacing: 2) {
            ForEach(1..<10, id: \.self) { index in
                pickerButton(index: index) {
                    viewModel.markerPublisher.send(index)
                }
            }
        }
    }

    func pickerButton(index: Int, action: @escaping () -> Void) -> some View {
        Button(action: {
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
        .frame(width: 44, height: 44)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
