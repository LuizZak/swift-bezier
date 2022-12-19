import XCTest

@testable import SwiftBezier

class QuadraticSolverTests: XCTestCase {
    func testSolveDoubleQuadratic() throws {
        let a = -7.0
        let b = 2.0
        let c = 1.0

        let result = try XCTUnwrap(QuadraticSolver.solveDouble(a: a, b: b, c: c))

        XCTAssertEqual(result.x0, -0.2612038749637415)
        XCTAssertEqual(result.x1, 0.5469181606780272, accuracy: 1e-10)
    }

    func testSolveQuadratic() throws {
        let a = -7.0
        let b = 2.0
        let c = 1.0

        let result = try XCTUnwrap(QuadraticSolver.solve(a: a, b: b, c: c))

        XCTAssertEqual(result.x0, -0.2612038749637415, accuracy: 1e-10)
        XCTAssertEqual(result.x1, 0.5469181606780272, accuracy: 1e-10)
    }

    func testSolveQuadratic_noRoots() throws {
        let a = -2.0
        let b = 3.0
        let c = -2.0

        XCTAssertNil(QuadraticSolver.solve(a: a, b: b, c: c))
    }
}
