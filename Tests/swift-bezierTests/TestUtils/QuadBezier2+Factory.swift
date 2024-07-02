import SwiftBezier

extension QuadBezier2 where Output == Bezier2DPoint {
    /// Returns a Bézier quadratic object that is composed of three control points
    /// that form a crescent shape, like the underside of a wave cusp:
    ///
    /// ```
    ///              (3)
    ///        ↗
    /// (2)
    ///
    ///    ↖
    ///
    ///     (1)
    /// ```
    ///
    /// Coordinates are in screen coordinates space.
    static func makeWaveCusp() -> Self {
        let p0 = Bezier2DPoint(x: 80.0, y: 250.0)
        let p1 = Bezier2DPoint(x: 20.0, y: 110.0)
        let p2 = Bezier2DPoint(x: 220.0, y: 60.0)

        return .init(p0: p0, p1: p1, p2: p2)
    }

    /// Returns a Bézier quadratic object that is composed of three control points
    /// that form a U-like shape:
    ///
    /// ```
    /// (1)         (3)
    ///
    ///    ↘       ↗
    ///       (2)
    /// ```
    ///
    /// Coordinates are in screen coordinates space.
    static func makeU() -> Self {
        let p0 = Bezier2DPoint(x: 0.0, y: 0.0)
        let p1 = Bezier2DPoint(x: 110.0, y: 90.0)
        let p2 = Bezier2DPoint(x: 220.0, y: 0.0)

        return .init(p0: p0, p1: p1, p2: p2)
    }
}
