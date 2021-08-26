import SwiftUI

struct SudokuGridView: View {
    let size: CGSize
    @EnvironmentObject var viewModel: SudokuViewModel

    var body: some View {
        ZStack(alignment: .center) {
            ForEach((0...3), id: \.self) { index in
                Rectangle()
                    .fill(Color.primary)
                    .frame(width: 3, height: size.height)
                    .position(x: size.width/3 * CGFloat(index))
            }
            .offset(y: size.width/2)

            ForEach((0...3), id: \.self) { index in
                Rectangle()
                    .fill(Color.primary)
                    .frame(width: size.width, height: 3)
                    .position(x: size.width)
                    .position(y: size.height/3 * CGFloat(index) + size.height/2)
            }
        }
        .padding(0)
    }
}

struct SudokuGridView_Previews: PreviewProvider {
    static var previews: some View {
        let state = SudokuState()
        let data = SudokuTestData(state: state)
        let viewModel = SudokuViewModel(data: data, state: state)
        Rectangle()
            .fill(Color.yellow)
            .frame(width: 344, height: 344)
            .overlay(
                GeometryReader { reader in
                    SudokuGridView(size: reader.size)
                        .environmentObject(viewModel)
                }
            )
    }
}
