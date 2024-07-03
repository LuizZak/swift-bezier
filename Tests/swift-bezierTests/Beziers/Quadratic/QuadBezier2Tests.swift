import XCTest

@testable import SwiftBezier

class QuadBezier2Tests: XCTestCase {
    // 'System-under-test' typealias for the object we are going to test.
    typealias Sut = QuadBezier2<Bezier2DPoint>

    func testBoundingRegion_waveCuspBezier() {
        let sut = Sut.makeWaveCusp()

        let (minimum, maximum) = sut.boundingRegion()

        XCTAssertEqual(minimum, .init(x: 66.15384615384615, y: 60.0))
        XCTAssertEqual(maximum, .init(x: 220.0, y: 250.0))
    }

    func testExtremas() {
        let sut = Sut.makeWaveCusp()

        let (x, y) = sut.extremas()

        assertBezierEquals(x, .init(p0: .init(x: 0.0, y: 80.0), p1: .init(x: 0.5, y: 20.0), p2: .init(x: 1.0, y: 220.0)))
        assertBezierEquals(y, .init(p0: .init(x: 0.0, y: 250.0), p1: .init(x: 0.5, y: 110.0), p2: .init(x: 1.0, y: 60.0)))
    }

    func testRoots_waveCusp() {
        let sut = Sut.makeWaveCusp()

        let (x, y) = sut.roots()

        assertEquals(x, 0.23076923076923078)
        assertEquals(y, nil)
    }

    func testRoots_uShape() {
        let sut = Sut.makeU()

        let (x, y) = sut.roots()

        assertEquals(x, nil)
        assertEquals(y, 0.5)
    }

    func testRotated() {
        let sut = Sut.makeWaveCusp()

        let result = sut.rotated(by: .pi / 2)

        assertBezierEquals(
            result,
            .init(
                p0: .init(x: -250.0, y: 80.00000000000001),
                p1: .init(x: -110.0, y: 20.000000000000007),
                p2: .init(x: -59.999999999999986, y: 220.0)
            )
        )
    }

    func testAligned_waveCusp() {
        let sut = Sut.makeWaveCusp()
        let line = LinearBezier2D(p0: .init(x: 20, y: 40), p1: .init(x: 30, y: 30))
        TestFixture.beginFixture(lineScale: 2, renderScale: 1) { fixture in
            fixture.add(bezier: sut)
            fixture.add(bezier: line)

            fixture.asserter(
                sut.aligned(along: line)
            )
            .assertBezierEquals(
                .init(
                    p0: .init(x: -106.06601717798213, y: 190.9188309203678),
                    p1: .init(x: -49.49747468305833, y: 49.49747468305832),
                    p2: .init(x: 127.27922061357853, y: 155.56349186104046)
                )
            )
        }
    }

    func testApproximateIntersection() {
        let c1 = Sut(p0: .init(x: 71, y: 38), p1: .init(x: -89, y: 58), p2: .init(x: -12, y: -60))
        let c2 = Sut(p0: .init(x: -47, y: -42), p1: .init(x: 84, y: -13), p2: .init(x: -191, y: 12))
        TestFixture.beginFixture { fixture in
            fixture.add(bezier: c1)
            fixture.add(bezier: c2)

            let intersections = c1.approximateIntersection(with: c2, threshold: 0.1)

            fixture.asserter(intersections)
                .assertEquals(
                    [(0.8935546875, 0.09521484375), (0.74365234375, 0.599609375), (0.744140625, 0.59912109375), (0.744140625, 0.599609375)],
                    by: { $0.elementsEqual($1, by: ==) }
                )
        }
    }
}
