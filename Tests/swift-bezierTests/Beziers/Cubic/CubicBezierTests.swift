import XCTest

@testable import SwiftBezier

class CubicBezierTests: XCTestCase {
    // 'System-under-test' typealias for the object we are going to test.
    typealias Sut = CubicBezier<Bezier2DPoint>

    func testCompute_atZero() {
        let sut = Sut.makeZigZagBezier()

        let result = sut.compute(at: 0.0)

        XCTAssertEqual(result, sut.p0)
    }

    func testCompute_atOne() {
        let sut = Sut.makeZigZagBezier()

        let result = sut.compute(at: 1.0)

        XCTAssertEqual(result, sut.p3)
    }

    func testCompute_atHalf() {
        let sut = Sut.makeZigZagBezier()
        // for this test Bézier, this produces the correct expected result
        let expected = sut.p0.lerp(to: sut.p3, factor: 0.5)

        let result = sut.compute(at: 0.5)

        XCTAssertEqual(result, expected)
    }

    func testSolveDeCasteljau_atHalf() {
        let sut = Sut.makeZigZagBezier()
        // for this test Bézier, this produces the correct expected result
        let expected = sut.p0.lerp(to: sut.p3, factor: 0.5)

        let result = sut.solveDeCasteljau(at: 0.5)

        XCTAssertEqual(result, expected)
    }

    func testComputeSeries_zeroSteps() {
        let sut = Sut.makeWavyBezier()

        let result = sut.computeSeries(steps: 0)

        XCTAssertEqual(result, [
            sut.p0, sut.p3
        ])
    }

    func testComputeSeries_oneStep() {
        let sut = Sut.makeWavyBezier()

        let result = sut.computeSeries(steps: 1)

        XCTAssertEqual(result, [
            sut.p0,
            sut.p0.lerp(to: sut.p3, factor: 0.5), // Known half-point of this test Bézier
            sut.p3
        ])
    }

    func testComputeSeries() {
        let sut = Sut.makeWavyBezier()

        let result = sut.computeSeries(steps: 20)

        XCTAssertEqual(result.count, 22)
    }

    func testSplit() {
        let sut = Sut.makeWavyBezier()
        let expectedLeft = Sut(
            p0: .init(x: 5.0, y: 13.0),
            p1: .init(x: 5.45, y: 10.899999999999999),
            p2: .init(x: 6.395, y: 10.689999999999998),
            p3: .init(x: 7.5379999999999985, y: 11.235999999999997)
        )
        let expectedRight = Sut(
            p0: .init(x: 7.5379999999999985, y: 11.235999999999997),
            p1: .init(x: 10.204999999999998, y: 12.509999999999998),
            p2: .init(x: 13.95, y: 17.9),
            p3: .init(x: 15.0, y: 13.0)
        )

        let (left, right) = sut.split(at: 0.3)

        assertBezierEquals(left, expectedLeft, accuracy: 1e-15)
        assertBezierEquals(right, expectedRight, accuracy: 1e-15)
    }

    func testSplit_t0() {
        let sut = Sut.makeWavyBezier()

        let (left, right) = sut.split(at: 0.0)

        assertBezierEquals(left, .init(p0: sut.p0, p1: sut.p0, p2: sut.p0, p3: sut.p0))
        assertBezierEquals(right, sut)
    }

    func testSplit_t1() {
        let sut = Sut.makeWavyBezier()

        let (left, right) = sut.split(at: 1.0)

        assertBezierEquals(left, sut)
        assertBezierEquals(right, .init(p0: sut.p3, p1: sut.p3, p2: sut.p3, p3: sut.p3))
    }

    func testDerivate() {
        let sut = Sut.makeTrapezoidalBezier()
        let expected = Sut.DerivativeBezier(
            p0: .init(x: 4.5, y: -21.0),
            p1: .init(x: 21.0, y: 0.0),
            p2: .init(x: 4.5, y: 21.0)
        )

        let result = sut.derivate()

        assertBezierEquals(result, expected)
    }

    func testLength_linear() {
        let sut = Sut.makeHorizontalLineBezier()

        let result = sut.length()

        assertEquals(result, 10.0, accuracy: 1e-14)
    }

    func testLength_wavyBezier() {
        let sut = Sut.makeWavyBezier()

        let result = sut.length()

        assertEquals(result, 13.639478612762339, accuracy: 1e-14)
    }

    func testLength_waveCusp() {
        let sut = Sut.makeWaveCusp()

        let result = sut.length()

        assertEquals(result, 307.67326535085067, accuracy: 1e-14)
    }

    func testTranslated() {
        let sut = Sut.makeWavyBezier()

        let result = sut.translated(by: .init(x: 5.0, y: -3.0))

        assertBezierEquals(
            result,
            .init(
                p0: .init(x: 10.0, y: 10.0),
                p1: .init(x: 11.5, y: 3.0),
                p2: .init(x: 18.5, y: 17.0),
                p3: .init(x: 20.0, y: 10.0)
            )
        )
    }
}
