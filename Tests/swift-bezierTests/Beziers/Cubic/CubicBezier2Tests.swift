import XCTest

@testable import SwiftBezier

class CubicBezier2DTests: XCTestCase {
    // 'System-under-test' typealias for the object we are going to test.
    typealias Sut = CubicBezier2<Bezier2DPoint>

    func testBoundingRegion_trapezoidBezier() {
        // This tests a case where the quadratic formula being solved ends up
        // being linear, instead.
        let sut = Sut.makeTrapezoidalBezier()

        let (minimum, maximum) = sut.boundingRegion()

        XCTAssertEqual(minimum, .init(x: 5.0, y: 7.75))
        XCTAssertEqual(maximum, .init(x: 15.0, y: 13.0))
    }

    func testBoundingRegion_wavyBezier() {
        let sut = Sut.makeWavyBezier()

        let (minimum, maximum) = sut.boundingRegion()

        XCTAssertEqual(minimum.x, 5.0, accuracy: 1e-10)
        XCTAssertEqual(minimum.y, 10.979274057836308, accuracy: 1e-10)
        XCTAssertEqual(maximum.x, 15.0, accuracy: 1e-10)
        XCTAssertEqual(maximum.y, 15.020725942163693, accuracy: 1e-10)
    }

    func testBoundingRegion_horizontalLineBezier() {
        let sut = Sut.makeHorizontalLineBezier()

        let (minimum, maximum) = sut.boundingRegion()

        XCTAssertEqual(minimum.x, 5.0, accuracy: 1e-10)
        XCTAssertEqual(minimum.y, 6.0, accuracy: 1e-10)
        XCTAssertEqual(maximum.x, 15.0, accuracy: 1e-10)
        XCTAssertEqual(maximum.y, 6.0, accuracy: 1e-10)
    }

    func testExtremas() {
        let sut = Sut.makeWavyBezier()

        let (x, y) = sut.extremas()

        assertBezierEquals(x, .init(p0: .init(x: 0.0, y: 5.0), p1: .init(x: 0.3333333333333333, y: 6.5), p2: .init(x: 0.6666666666666666, y: 13.5), p3: .init(x: 1.0, y: 15.0)))
        assertBezierEquals(y, .init(p0: .init(x: 0.0, y: 13.0), p1: .init(x: 0.3333333333333333, y: 6.0), p2: .init(x: 0.6666666666666666, y: 20.0), p3: .init(x: 1.0, y: 13.0)))
    }

    func testRoots_wavyBezier() {
        let sut = Sut.makeWavyBezier()

        let (x0, x1, y0, y1) = sut.roots()

        assertEquals(x0, nil)
        assertEquals(x1, nil)
        assertEquals(y0, 0.2113248654051871)
        assertEquals(y1, 0.7886751345948129)
    }

    func testRoots_waveCuspBezier() {
        let sut = Sut.makeWaveCusp()

        let (x0, x1, y0, y1) = sut.roots()

        assertEquals(x0, 0.12918492324974712)
        assertEquals(x1, nil)
        assertEquals(y0, nil)
        assertEquals(y1, nil)
    }

    func testRotated() {
        let sut = Sut.makeWavyBezier()

        let result = sut.rotated(by: .pi / 2)

        assertBezierEquals(
            result,
            .init(
                p0: .init(x: -13.0, y: 5.000000000000001),
                p1: .init(x: -6.0, y: 6.5),
                p2: .init(x: -20.0, y: 13.500000000000002),
                p3: .init(x: -12.999999999999998, y: 15.0)
            )
        )
    }
}
