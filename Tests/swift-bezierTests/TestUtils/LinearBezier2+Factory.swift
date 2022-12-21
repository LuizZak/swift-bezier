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

    /// Returns a linear Bézier that descends from a higher control point to a
    /// lower one:
    ///
    /// ```
    ///         (2)
    ///      ↗
    /// (1)
    /// ```
    ///
    /// Coordinates are in screen coordinates space.
    static func makeDescendingLineBezier() -> Self {
        return .init(
            p0: .init(x: 5, y: 20),
            p1: .init(x: 20, y: 10)
        )
    }
}
