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
                    .font(.system(size: cell.fontSize, weight: cell.fontWeight, design: .rounded))
                    .foregroundColor(cell.color)
            )
            .overlay(
                markersView(cell: cell)
                    .padding(0)
            )
            .background(
                viewModel.cellBackgroundColors[cell.id]
            )
            .gesture(TapGesture(count: 2).onEnded {
                UserAction.cellDoubleTouch.send(obj: cell.id)
            })
            .simultaneousGesture(TapGesture().onEnded {
                UserAction.cellTouch.send(obj: cell.id)
            })
    }

    func markersView(cell: CellViewModel) -> some View {
        GeometryReader { reader in
            LazyVGrid(columns: markerColumns, spacing: 0) {
                ForEach(0..<9, id: \.self) { index in
                    Text(cell.markers[index])
                        .minimumScaleFactor(0.1)
                        .multilineTextAlignment(.center)
                        .foregroundColor(cell.markerConflicts[index] ? .red : .primary)
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
        let controller = SudokuController(puzzleSource: TestPuzzleSource())
        UserAction.startGame.send()
        UserAction.cellTouch.send(obj: 0)
        for index in 1...9 {
            UserAction.markerTouch.send(obj: index)
        }
        UserAction.cellTouch.send(obj: 1)
        UserAction.numberTouch.send(obj: 2)
        UserAction.cellTouch.send(obj: 2)
        UserAction.numberTouch.send(obj: 3)
        UserAction.cellTouch.send(obj: 3)
        return VStack {
            ForEach(0..<4) { index in
                SudokuCellView(cell: controller.viewModel.cells[index])
                    .frame(width: len, height: len)
            }
        }
        .environmentObject(controller.viewModel)
        .preferredColorScheme(.dark)
    }
}
