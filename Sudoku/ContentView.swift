import SwiftUI

struct ContentView: View {
    @StateObject var viewModel: SudokuViewModel

    init() {
        let viewModel = SudokuViewModel()
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        HStack {
            VStack {
                Text("Numbers")
                numberPicker
            }
            VStack {
                Text("Markers")
                markerPicker
            }
        }
        .padding()
        .onAppear {
            viewModel.startGame()
        }
    }
    
    var numberPicker: some View {
        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())], alignment: .center, spacing: 20) {
            ForEach(1..<10, id: \.self) { index in
                Button(action: {
                    viewModel.numberPublisher.send(index)
                }, label: {
                    Text("\(index)")
                })
            }
        }
    }
    
    var markerPicker: some View {
        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())], alignment: .center, spacing: 20) {
            ForEach(1..<10, id: \.self) { index in
                Button(action: {
                    viewModel.markerPublisher.send(index)
                }, label: {
                    Text("\(index)")
                })
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
