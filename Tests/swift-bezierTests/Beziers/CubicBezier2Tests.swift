import XCTest

@testable import SwiftBezier

class CubicBezier2DTests: XCTestCase {
    // 'System-under-test' typealias for the object we are going to test.
    typealias Sut = CubicBezier2<Bezier2DPoint>

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

    func testBoundingRegion_zigZagBezier() {
        let sut = Sut.makeZigZagBezier()

        let (minimum, maximum) = sut.boundingRegion()

        XCTAssertEqual(minimum, sut.p0)
        XCTAssertEqual(maximum, sut.p3)
    }

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
}
