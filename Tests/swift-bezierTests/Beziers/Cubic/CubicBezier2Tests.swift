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

    func testAligned_wavyBezier() {
        let sut = Sut.makeWavyBezier()
        let line = LinearBezier2D(p0: .init(x: 2, y: 4), p1: .init(x: 3, y: 3))
        TestFixture.beginFixture(lineScale: 20, renderScale: 20) { fixture in
            fixture.add(bezier: sut)
            fixture.add(bezier: line)

            fixture.asserter(
                sut.aligned(along: line)
            )
            .assertBezierEquals(
                .init(
                    p0: .init(x: -4.242640687119286, y: 8.485281374238571),
                    p1: .init(x: 1.7677669529663687, y: 4.596194077712559),
                    p2: .init(x: -3.1819805153394647, y: 19.445436482630058),
                    p3: .init(x: 2.828427124746189, y: 15.556349186104047)
                )
            )
        }
    }

    func testApproximateIntersection() {
        let c1 = Sut(p0: .init(x: -93.84523543737022, y: 54.584285962187664), p1: .init(x: 36, y: 18), p2: .init(x: 106, y: 109), p3: .init(x: 94, y: -33))
        let c2 = Sut(p0: .init(x: 106.3978860946466, y: -98.52483470629815), p1: .init(x: 149, y: 65), p2: .init(x: -65, y: 127), p3: .init(x: -65, y: -5))
        TestFixture.beginFixture { fixture in
            fixture.add(bezier: c1)
            fixture.add(bezier: c2)

            let intersections = c1.approximateIntersection(with: c2, threshold: 1.0)

            fixture.asserter(intersections)
                .assertEquals(
                    [(0.12109375, 0.828125), (0.5, 0.4375), (0.50390625, 0.4375), (0.880859375, 0.263671875), (0.876953125, 0.265625), (0.87890625, 0.265625)],
                    by: { $0.elementsEqual($1, by: ==) }
                )
        }
    }
}
