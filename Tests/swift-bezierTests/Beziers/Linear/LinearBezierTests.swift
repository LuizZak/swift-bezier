import XCTest

@testable import SwiftBezier

class LinearBezierTests: XCTestCase {
    // 'System-under-test' typealias for the object we are going to test.
    typealias Sut = LinearBezier<Bezier2DPoint>

    func testCompute_atZero() {
        let sut = Sut.makeAscendingLineBezier()

        let result = sut.compute(at: 0.0)

        XCTAssertEqual(result, sut.p0)
    }

    func testCompute_atOne() {
        let sut = Sut.makeAscendingLineBezier()

        let result = sut.compute(at: 1.0)

        XCTAssertEqual(result, sut.p1)
    }

    func testCompute_atHalf() {
        let sut = Sut.makeAscendingLineBezier()
        let expected = sut.p0.lerp(to: sut.p1, factor: 0.5)

        let result = sut.compute(at: 0.5)

        XCTAssertEqual(result, expected)
    }

    func testSolveDeCasteljau_atHalf() {
        let sut = Sut.makeAscendingLineBezier()
        let expected = sut.p0.lerp(to: sut.p1, factor: 0.5)

        let result = sut.solveDeCasteljau(at: 0.5)

        XCTAssertEqual(result, expected)
    }

    func testComputeSeries_zeroSteps() {
        let sut = Sut.makeAscendingLineBezier()

        let result = sut.computeSeries(steps: 0)

        XCTAssertEqual(result, [
            sut.p0, sut.p1
        ])
    }

    func testComputeSeries_oneStep() {
        let sut = Sut.makeAscendingLineBezier()

        let result = sut.computeSeries(steps: 1)

        XCTAssertEqual(result, [
            sut.p0,
            sut.p0.lerp(to: sut.p1, factor: 0.5),
            sut.p1
        ])
    }

    func testComputeSeries() {
        let sut = Sut.makeAscendingLineBezier()

        let result = sut.computeSeries(steps: 20)

        XCTAssertEqual(result.count, 22)
    }

    func testSplit() {
        let sut = Sut.makeAscendingLineBezier()
        let expectedLeft = Sut(
            p0: .init(x: 5.0, y: 10.0),
            p1: .init(x: 9.5, y: 13.0)
        )
        let expectedRight = Sut(
            p0: .init(x: 9.5, y: 13.0),
            p1: .init(x: 20, y: 20)
        )

        let (left, right) = sut.split(at: 0.3)

        assertBezierEquals(left, expectedLeft, accuracy: 1e-15)
        assertBezierEquals(right, expectedRight, accuracy: 1e-15)
    }

    func testSplit_t0() {
        let sut = Sut.makeAscendingLineBezier()

        let (left, right) = sut.split(at: 0.0)

        assertBezierEquals(left, .init(p0: sut.p0, p1: sut.p0))
        assertBezierEquals(right, sut)
    }

    func testSplit_t1() {
        let sut = Sut.makeAscendingLineBezier()

        let (left, right) = sut.split(at: 1.0)

        assertBezierEquals(left, sut)
        assertBezierEquals(right, .init(p0: sut.p1, p1: sut.p1))
    }

    func testLength_ascendingLineBezier() {
        let sut = Sut.makeAscendingLineBezier()

        let result = sut.length()

        assertEquals(result, 18.027756377319946)
    }
}
