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
                Group {
                    if viewModel.useColor {
                        if !cell.textSymbol.text.isEmpty {
                            Circle()
                                .foregroundColor(cell.colorSymbol.color)
                                .padding(isPad ? 13 : 7)
                        }
                    } else {
                        Text("\(cell.textSymbol.text)")
                            .font(.system(size: cell.textSymbol.fontSize, weight: cell.textSymbol.fontWeight, design: .rounded))
                            .foregroundColor(cell.textSymbol.color)
                    }
                }
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

    func markerCellView(cell: CellViewModel, index: Int, size: CGSize) -> some View {
        Group {
            if viewModel.useColor {
                Circle()
                    .foregroundColor(cell.colorSymbol.markerColors[index])
                    .padding(isPad ? 4 : 3)
                    .background(
                        Rectangle()
                            .foregroundColor(cell.colorSymbol.markerConflicts[index] ? .red.opacity(0.75) : .clear)
                            .aspectRatio(1, contentMode: .fit)
                    )
            } else {
                Text(cell.textSymbol.markers[index])
                    .minimumScaleFactor(0.1)
                    .multilineTextAlignment(.center)
                    .foregroundColor(cell.textSymbol.markerConflicts[index] ? .red : .primary)
            }
        }
        .frame(width: size.width, height: size.height/3)
    }

    func markersView(cell: CellViewModel) -> some View {
        GeometryReader { reader in
            LazyVGrid(columns: markerColumns, spacing: 0) {
                ForEach(0..<9, id: \.self) { index in
                    markerCellView(cell: cell, index: index, size: reader.size)
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
        let controller2 = SudokuController(puzzleSource: TestPuzzleSource())
        UserAction.startGame.send()
        controller2.viewModel.useColor = true
        UserAction.cellTouch.send(obj: 0)
        for index in 1...9 {
            UserAction.markerTouch.send(obj: index)
        }
        UserAction.cellTouch.send(obj: 1)
        UserAction.numberTouch.send(obj: 2)
        UserAction.cellTouch.send(obj: 2)
        UserAction.numberTouch.send(obj: 3)
        UserAction.cellTouch.send(obj: 3)
        return HStack {
            VStack {
                ForEach(0..<4) { index in
                    SudokuCellView(cell: controller.viewModel.cells[index])
                        .frame(width: len, height: len)
                }
            }
            .environmentObject(controller.viewModel)
            VStack {
                ForEach(0..<4) { index in
                    SudokuCellView(cell: controller.viewModel.cells[index])
                        .frame(width: len, height: len)
                }
            }
            .environmentObject(controller2.viewModel)
        }
        .preferredColorScheme(.light)
    }
}
