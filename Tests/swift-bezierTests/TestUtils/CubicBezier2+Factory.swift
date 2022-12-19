import SwiftBezier

extension CubicBezier2 where Output == Bezier2DPoint {
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
}
