import Foundation

struct SudokuConstants {
    static let NUMROWS = 9
    static let NUMCOLS = 9
    public static let NUMCELLS = NUMROWS * NUMCOLS
    public static let CELLINDEXES = Array(0..<NUMCELLS)
    //  swiftlint:disable:next line_length
    static let GRIDFORINDEX = [0, 0, 0, 1, 1, 1, 2, 2, 2, 0, 0, 0, 1, 1, 1, 2, 2, 2, 0, 0, 0, 1, 1, 1, 2, 2, 2, 3, 3, 3, 4, 4, 4, 5, 5, 5, 3, 3, 3, 4, 4, 4, 5, 5, 5, 3, 3, 3, 4, 4, 4, 5, 5, 5, 6, 6, 6, 7, 7, 7, 8, 8, 8, 6, 6, 6, 7, 7, 7, 8, 8, 8, 6, 6, 6, 7, 7, 7, 8, 8, 8]
    static let ROWINDEXES = [
        [0, 1, 2, 3, 4, 5, 6, 7, 8],
        [9, 10, 11, 12, 13, 14, 15, 16, 17],
        [18, 19, 20, 21, 22, 23, 24, 25, 26],
        [27, 28, 29, 30, 31, 32, 33, 34, 35],
        [36, 37, 38, 39, 40, 41, 42, 43, 44],
        [45, 46, 47, 48, 49, 50, 51, 52, 53],
        [54, 55, 56, 57, 58, 59, 60, 61, 62],
        [63, 64, 65, 66, 67, 68, 69, 70, 71],
        [72, 73, 74, 75, 76, 77, 78, 79, 80]
    ]
    static let COLINDEXES = [
        [0, 9, 18, 27, 36, 45, 54, 63, 72],
        [1, 10, 19, 28, 37, 46, 55, 64, 73],
        [2, 11, 20, 29, 38, 47, 56, 65, 74],
        [3, 12, 21, 30, 39, 48, 57, 66, 75],
        [4, 13, 22, 31, 40, 49, 58, 67, 76],
        [5, 14, 23, 32, 41, 50, 59, 68, 77],
        [6, 15, 24, 33, 42, 51, 60, 69, 78],
        [7, 16, 25, 34, 43, 52, 61, 70, 79],
        [8, 17, 26, 35, 44, 53, 62, 71, 80]
    ]
    static let GRIDINDEXES = [
        [0, 1, 2, 9, 10, 11, 18, 19, 20],
        [3, 4, 5, 12, 13, 14, 21, 22, 23],
        [6, 7, 8, 15, 16, 17, 24, 25, 26],
        [27, 28, 29, 36, 37, 38, 45, 46, 47],
        [30, 31, 32, 39, 40, 41, 48, 49, 50],
        [33, 34, 35, 42, 43, 44, 51, 52, 53],
        [54, 55, 56, 63, 64, 65, 72, 73, 74],
        [57, 58, 59, 66, 67, 68, 75, 76, 77],
        [60, 61, 62, 69, 70, 71, 78, 79, 80]
    ]
    public static let levelClueCounts = [36, 33, 30, 27]

    public static func indexToRow(_ cellIndex: Int) -> Int {
        return cellIndex / SudokuConstants.NUMROWS
    }

    public static func indexToCol(_ cellIndex: Int) -> Int {
        return cellIndex % SudokuConstants.NUMCOLS
    }

    public static func indexToGrid(_ cellIndex: Int) -> Int {
        return SudokuConstants.GRIDFORINDEX[cellIndex]
    }

    public static func rowColGridIndexes(_ cellIndex: Int) -> [Int] {
        SudokuConstants.rowIndexes(cellIndex) +
            SudokuConstants.colIndexes(cellIndex) +
            SudokuConstants.gridIndexes(cellIndex)
    }

    public static func rowIndexes(_ cellIndex: Int) -> [Int] {
        return SudokuConstants.ROWINDEXES[SudokuConstants.indexToRow(cellIndex)]
    }

    public static func colIndexes(_ cellIndex: Int) -> [Int] {
        return SudokuConstants.COLINDEXES[SudokuConstants.indexToCol(cellIndex)]
    }

    public static func gridIndexes(_ cellIndex: Int) -> [Int] {
        return SudokuConstants.GRIDINDEXES[SudokuConstants.indexToGrid(cellIndex)]
    }
}
