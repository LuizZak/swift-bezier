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
}
