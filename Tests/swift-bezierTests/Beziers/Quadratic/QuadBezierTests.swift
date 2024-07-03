import XCTest

@testable import SwiftBezier

class QuadBezierTests: XCTestCase {
    // 'System-under-test' typealias for the object we are going to test.
    typealias Sut = QuadBezier<Bezier2DPoint>

    func testCompute_atZero() {
        let sut = Sut.makeWaveCusp()

        let result = sut.compute(at: 0.0)

        XCTAssertEqual(result, sut.p0)
    }

    func testCompute_atOne() {
        let sut = Sut.makeWaveCusp()

        let result = sut.compute(at: 1.0)

        XCTAssertEqual(result, sut.p2)
    }

    func testCompute_atHalf() {
        let sut = Sut.makeWaveCusp()
        let expected = Sut.Output(
            x: 85.0,
            y: 132.5
        )

        let result = sut.compute(at: 0.5)

        XCTAssertEqual(result, expected)
    }

    func testSolveDeCasteljau_atHalf() {
        let sut = Sut.makeWaveCusp()
        let expected = Sut.Output(
            x: 85.0,
            y: 132.5
        )

        let result = sut.solveDeCasteljau(at: 0.5)

        XCTAssertEqual(result, expected)
    }

    func testComputeSeries_zeroSteps() {
        let sut = Sut.makeWaveCusp()

        let result = sut.computeSeries(steps: 0)

        XCTAssertEqual(result, [
            sut.p0, sut.p2
        ])
    }

    func testComputeSeries_oneStep() {
        let sut = Sut.makeWaveCusp()

        let result = sut.computeSeries(steps: 1)

        XCTAssertEqual(result, [
            sut.p0,
            Sut.Output(x: 85.0,y: 132.5),
            sut.p2
        ])
    }

    func testComputeSeries() {
        let sut = Sut.makeWaveCusp()

        let result = sut.computeSeries(steps: 20)

        XCTAssertEqual(result.count, 22)
    }

    func testSplit() {
        let sut = Sut.makeWaveCusp()
        let expectedLeft = Sut(
            p0: .init(x: 80.0, y: 250.0),
            p1: .init(x: 62.0, y: 208.0),
            p2: .init(x: 67.4, y: 174.1)
        )
        let expectedRight = Sut(
            p0: .init(x: 67.4, y: 174.1),
            p1: .init(x: 80.0, y: 95.0),
            p2: .init(x: 220.0, y: 60.0)
        )

        let (left, right) = sut.split(at: 0.3)

        assertBezierEquals(left, expectedLeft, accuracy: 1e-15)
        assertBezierEquals(right, expectedRight, accuracy: 1e-15)
    }

    func testSplit_t0() {
        let sut = Sut.makeWaveCusp()

        let (left, right) = sut.split(at: 0.0)

        assertBezierEquals(left, .init(p0: sut.p0, p1: sut.p0, p2: sut.p0))
        assertBezierEquals(right, sut)
    }

    func testSplit_t1() {
        let sut = Sut.makeWaveCusp()

        let (left, right) = sut.split(at: 1.0)

        assertBezierEquals(left, sut)
        assertBezierEquals(right, .init(p0: sut.p2, p1: sut.p2, p2: sut.p2))
    }

    func testDerivate() {
        let sut = Sut.makeWaveCusp()
        let expected = Sut.DerivativeBezier(
            p0: .init(x: -120.0, y: -280.0),
            p1: .init(x: 400.0, y: -100.0)
        )

        let result = sut.derivate()

        assertBezierEquals(result, expected)
    }

    func testLength_linear() {
        let sut = Sut.makeHorizontalLineBezier()

        let result = sut.length()

        assertEquals(result, 10.0)
    }

    func testLength_uShape() {
        let sut = Sut.makeU()

        let result = sut.length()

        assertEquals(result, 242.53021779146)
    }

    func testLength_waveCusp() {
        let sut = Sut.makeWaveCusp()

        let result = sut.length()

        assertEquals(result, 279.69723074313794)
    }

    func testTranslated() {
        let sut = Sut.makeWaveCusp()

        let result = sut.translated(by: .init(x: 5.0, y: -3.0))

        assertBezierEquals(
            result,
            .init(
                p0: .init(x: 85.0, y: 247.0),
                p1: .init(x: 25.0, y: 107.0),
                p2: .init(x: 225.0, y: 57.0)
            )
        )
    }
}
