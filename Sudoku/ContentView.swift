import SwiftUI

struct ContentView: View {
    @StateObject var viewModel: SudokuViewModel
    let boardColumns = Array(repeating: GridItem(.flexible(), spacing: 0), count: 9)
    let pickerColumns = Array(repeating: GridItem(.flexible()), count: 3)

    init() {
        let viewModel = SudokuViewModel()
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        VStack {
            boardView
            HStack {
                VStack {
                    Text("Numbers")
                    numberPicker
                }
                Spacer(minLength: 24)
                VStack {
                    Text("Markers")
                    markerPicker
                }
            }
            .padding()
        }
        .padding()
        .onAppear {
            viewModel.startGame()
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
                    .background(
                        viewModel.selectionIndex == cell.id ? Color.green : .white
                    )
                    .onTapGesture {
                        viewModel.select(index: cell.id)
                    }
            }
        }
    }
    
    var numberPicker: some View {
        LazyVGrid(columns: pickerColumns, alignment: .center, spacing: 2) {
            ForEach(1..<10, id: \.self) { index in
                Button(action: {
                    viewModel.numberPublisher.send(index)
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
                            .bold()
                            .foregroundColor(.white)
                    )
                }
                )
            }
        }
    }
    
    var markerPicker: some View {
        LazyVGrid(columns: pickerColumns, spacing: 2) {
            ForEach(1..<10, id: \.self) { index in
                Button(action: {
                    viewModel.markerPublisher.send(index)
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
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
