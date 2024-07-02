import SwiftBezier

extension CubicBezier2 where Output == Bezier2DPoint {
    /// Returns a Bézier quadratic object that is composed of three control points
    /// that form a crescent shape, like the underside of a wave cusp:
    ///
    /// ```
    ///           ,> (4)
    ///         (3)
    ///      ↗
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
        let p3 = Bezier2DPoint(x: 250.0, y: 40.0)

        return .init(p0: p0, p1: p1, p2: p2, p3: p3)
    }

    /// Returns a Bézier curve object that is composed of four control points
    /// that alternate in a zig-zag pattern on top of a square set of points:
    ///
    /// ```
    /// (1)  ->  (2)
    ///
    ///      ↙
    ///
    /// (3)  ->  (4)
    /// ```
    ///
    /// Coordinates are in screen coordinates space.
    static func makeZigZagBezier(sideLength: Double = 10.0) -> Self {
        let origin = Bezier2DPoint(x: 5.0, y: 6.0)
        let p0 = Bezier2DPoint(x: 0.0, y: 0.0)
        let p1 = Bezier2DPoint(x: sideLength, y: 0.0)
        let p2 = Bezier2DPoint(x: 0.0, y: sideLength)
        let p3 = Bezier2DPoint(x: sideLength, y: sideLength)

        return .init(p0: p0 + origin, p1: p1 + origin, p2: p2 + origin, p3: p3 + origin)
    }

    /// Returns a Bézier curve object that is composed of four control points
    /// that form a trapezoidal shape:
    ///
    /// ```
    ///   (2)  ->  (3)
    ///   ↗          ↘
    /// (1)          (4)
    /// ```
    ///
    /// Coordinates are in screen coordinates space.
    static func makeTrapezoidalBezier(
        baseLength: Double = 10.0,
        topLength: Double = 7.0,
        height: Double = 7.0
    ) -> Self {

        let center = baseLength / 2

        let origin = Bezier2DPoint(x: 5.0, y: 6.0)
        let p0 = Bezier2DPoint(x: 0.0, y: height)
        let p1 = Bezier2DPoint(x: center - topLength / 2, y: 0)
        let p2 = Bezier2DPoint(x: center + topLength / 2, y: 0)
        let p3 = Bezier2DPoint(x: baseLength, y: height)

        return .init(p0: p0 + origin, p1: p1 + origin, p2: p2 + origin, p3: p3 + origin)
    }

    /// Returns a cubic Bézier curve object with a wavy pattern of points:
    ///
    /// ```
    ///   (2)
    ///   ↗
    /// (1)   ↘    (4)
    ///           ↗
    ///         (3)
    /// ```
    ///
    /// Equivalent to `makeTrapezoidBezier` Bézier builder, but with the third
    /// point being mirrored across the plane of (1) -> (4)
    ///
    /// Coordinates are in screen coordinates space.
    static func makeWavyBezier(
        baseLength: Double = 10.0,
        topLength: Double = 7.0,
        height: Double = 7.0
    ) -> Self {

        let center = baseLength / 2

        let origin = Bezier2DPoint(x: 5.0, y: 6.0)
        let p0 = Bezier2DPoint(x: 0.0, y: height)
        let p1 = Bezier2DPoint(x: center - topLength / 2, y: 0)
        let p2 = Bezier2DPoint(x: center + topLength / 2, y: height * 2)
        let p3 = Bezier2DPoint(x: baseLength, y: height)

        return .init(p0: p0 + origin, p1: p1 + origin, p2: p2 + origin, p3: p3 + origin)
    }

    /// Returns a Bézier curve object that is composed of four control points
    /// in a straight line horizontally:
    ///
    /// ```
    /// (1) -> (2) -> (3) -> (4)
    /// ```
    ///
    /// Coordinates are in screen coordinates space.
    static func makeHorizontalLineBezier(length: Double = 10.0) -> Self {
        let sep = Bezier2DPoint(x: length / 3.0, y: 0.0)

        let origin = Bezier2DPoint(x: 5.0, y: 6.0)
        let p0 = Bezier2DPoint.zero
        let p1 = sep
        let p2 = sep * 2
        let p3 = sep * 3

        return .init(p0: p0 + origin, p1: p1 + origin, p2: p2 + origin, p3: p3 + origin)
    }
}
