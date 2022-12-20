import SwiftBezier

extension LinearBezier2 where Output == Bezier2DPoint {
    /// Returns a linear Bézier that ascends from a lower control point to a
    /// higher one:
    ///
    /// ```
    /// (1)        
    ///      ↘
    ///         (2)
    /// ```
    ///
    /// Coordinates are in screen coordinates space.
    static func makeAscendingLineBezier() -> Self {
        return .init(
            p0: .init(x: 5, y: 10),
            p1: .init(x: 20, y: 20)
        )
    }
}
