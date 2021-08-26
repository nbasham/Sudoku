import SwiftUI

struct SudokuCellView: View {
    let cell: CellViewModel
    @EnvironmentObject var viewModel: SudokuViewModel
    @Environment(\.verticalSizeClass) var sizeClass
    private let markerColumns = Array(repeating: GridItem(.flexible(), spacing: 0), count: 3)

    var body: some View {
        Rectangle()
            .stroke()
            .aspectRatio(1, contentMode: .fill)
            .overlay(
                Text("\(cell.text)")
//                    .font(.system(size: sizeClass == .compact ? 8 : 32, design: .monospaced))
                    .foregroundColor(cell.color)
            )
            .overlay(
                markersView(cell: cell)
                    .padding(0)
            )
            .background(
                viewModel.cellBackgroundColors[cell.id]
            )
            .onTapGesture {
                viewModel.select(index: cell.id)
            }
    }

    func markersView(cell: CellViewModel) -> some View {
        GeometryReader { reader in
            LazyVGrid(columns: markerColumns, spacing: 0) {
                ForEach(0..<9, id: \.self) { index in
                    Text(cell.markers[index])
                        .minimumScaleFactor(0.1)
                        .multilineTextAlignment(.center)
                        .frame(width: reader.size.width, height: reader.size.height/3)
                }
            }
            .fixedSize()
        }
    }
}

struct SudokuCellView_Previews: PreviewProvider {
    static var previews: some View {
        let len: CGFloat = UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.pad ? 100 : 32
        let state = SudokuState()
        let data = SudokuTestData(state: state)
        let viewModel = SudokuViewModel(data: data, state: state)
        viewModel.startGame()
        viewModel.select(index: 0)
        for index in 1...9 {
            viewModel.markerPublisher.send(index)
        }
        viewModel.select(index: 1)
        viewModel.numberPublisher.send(2)
        viewModel.select(index: 2)
        viewModel.numberPublisher.send(3)
        viewModel.select(index: 3)
        return VStack {
            ForEach(0..<4) { index in
                SudokuCellView(cell: viewModel.cells[index])
                    .frame(width: len, height: len)
            }
        }
        .environmentObject(viewModel)
        .preferredColorScheme(.dark)
    }
}
