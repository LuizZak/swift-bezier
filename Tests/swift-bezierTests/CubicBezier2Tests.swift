import XCTest

@testable import SwiftBezier

class CubicBezier2DTests: XCTestCase {
    typealias CubicBezier2D = CubicBezier2<Bezier2DPoint>

    func testCompute_atZero() {
        let sut = makeZigZagBezier()

        let result = sut.compute(at: 0.0)

        XCTAssertEqual(result, sut.p0)
    }

    func testCompute_atOne() {
        let sut = makeZigZagBezier()

        let result = sut.compute(at: 1.0)

        XCTAssertEqual(result, sut.p3)
    }

    func testCompute_atHalf() {
        let sut = makeZigZagBezier()
        // for this test Bézier, this produces the correct expected result
        let expected = sut.p0.lerp(to: sut.p3, factor: 0.5)

        let result = sut.compute(at: 0.5)

        XCTAssertEqual(result, expected)
    }

    func testSolveDeCasteljau_atHalf() {
        let sut = makeZigZagBezier()
        // for this test Bézier, this produces the correct expected result
        let expected = sut.p0.lerp(to: sut.p3, factor: 0.5)

        let result = sut.solveDeCasteljau(at: 0.5)

        XCTAssertEqual(result, expected)
    }

    func testBoundingRegion_zigZagBezier() {
        let sut = makeZigZagBezier()

        let (minimum, maximum) = sut.boundingRegion()

        XCTAssertEqual(minimum, sut.p0)
        XCTAssertEqual(maximum, sut.p3)
    }

    func testBoundingRegion_trapezoidBezier() {
        // This tests a case where the quadratic formula being solved ends up
        // being linear, instead.
        let sut = makeTrapezoidalBezier()

        let (minimum, maximum) = sut.boundingRegion()

        XCTAssertEqual(minimum, .init(x: 5.0, y: 7.75))
        XCTAssertEqual(maximum, .init(x: 15.0, y: 13.0))
    }

    func testBoundingRegion_wavyBezier() {
        let sut = makeWavyBezier()

        let (minimum, maximum) = sut.boundingRegion()

        XCTAssertEqual(minimum.x, 5.0, accuracy: 1e-10)
        XCTAssertEqual(minimum.y, 10.979274057836308, accuracy: 1e-10)
        XCTAssertEqual(maximum.x, 15.0, accuracy: 1e-10)
        XCTAssertEqual(maximum.y, 15.020725942163693, accuracy: 1e-10)
    }

    // MARK: - Test internals

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
    func makeZigZagBezier(sideLength: Double = 10.0) -> CubicBezier2D {
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
    func makeTrapezoidalBezier(
        baseLength: Double = 10.0,
        topLength: Double = 7.0,
        height: Double = 7.0
    ) -> CubicBezier2D {

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
    func makeWavyBezier(
        baseLength: Double = 10.0,
        topLength: Double = 7.0,
        height: Double = 7.0
    ) -> CubicBezier2D {

        let center = baseLength / 2

        let origin = Bezier2DPoint(x: 5.0, y: 6.0)
        let p0 = Bezier2DPoint(x: 0.0, y: height)
        let p1 = Bezier2DPoint(x: center - topLength / 2, y: 0)
        let p2 = Bezier2DPoint(x: center + topLength / 2, y: height * 2)
        let p3 = Bezier2DPoint(x: baseLength, y: height)

        return .init(p0: p0 + origin, p1: p1 + origin, p2: p2 + origin, p3: p3 + origin)
    }
}
