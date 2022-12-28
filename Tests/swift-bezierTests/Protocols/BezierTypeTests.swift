import XCTest

@testable import SwiftBezier

class BezierTypeTests: XCTestCase {
    typealias TestBezier = CubicBezier2<Bezier2DPoint>

    func testProjectApproximate() {
        let sut = TestBezier.makeTrapezoidalBezier()
        let point = Bezier2DPoint(x: 0, y: 0)

        let result = sut.projectApproximate(
            to: point,
            steps: 50,
            maxIterations: 10,
            tolerance: 0.01
        )

        XCTAssertEqual(result.t, 0.27450980392156865, accuracy: 1e-10)
        XCTAssertEqual(result.output.x, 7.251117594288774, accuracy: 1e-10)
        XCTAssertEqual(result.output.y, 8.817762399077278, accuracy: 1e-10)
    }

    func testProjectApproximate_onP0() {
        let sut = TestBezier.makeTrapezoidalBezier()
        let point = sut.p0

        let result = sut.projectApproximate(
            to: point,
            steps: 50,
            maxIterations: 10,
            tolerance: 0.01
        )

        XCTAssertEqual(result.t, 0.0, accuracy: 1e-10)
        XCTAssertEqual(result.output, sut.p0)
    }

    func testProjectApproximate_onLastControlPoint() {
        let sut = TestBezier.makeTrapezoidalBezier()
        let point = sut.p3

        let result = sut.projectApproximate(
            to: point,
            steps: 50,
            maxIterations: 10,
            tolerance: 0.01
        )

        XCTAssertEqual(result.t, 1.0, accuracy: 1e-10)
        XCTAssertEqual(result.output, sut.p3)
    }

    func testProjectApproximate_horizontalLineBezier() {
        let sut = TestBezier.makeHorizontalLineBezier()
        let point = sut.p1.lerp(to: sut.p2, factor: 0.5) + .init(x: 0.0, y: 10.0)

        let result = sut.projectApproximate(
            to: point,
            steps: 50,
            maxIterations: 10,
            tolerance: 0.001
        )

        assertEquals(result.t, 0.5, accuracy: 1e-2)
        assertEquals(result.output, sut.p1.lerp(to: sut.p2, factor: 0.5), accuracy: 1e-1)
    }

    func testProjectApproximate_horizontalLineBezier_priorToP0() {
        let sut = TestBezier.makeHorizontalLineBezier()
        let point = sut.p0 - .init(x: 10.0, y: 0.0)

        let result = sut.projectApproximate(
            to: point,
            steps: 50,
            maxIterations: 10,
            tolerance: 0.01
        )

        assertEquals(result.t, 0.0, accuracy: 1e-10)
        assertEquals(result.output, sut.p0, accuracy: 1e-10)
    }
}
