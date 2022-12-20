import XCTest

@testable import SwiftBezier

class BinarySearchTests: XCTestCase {
    func testBinarySearchInput_rootSearch() {
        let start: Double = -500
        let end: Double = 800
        let maxIterations = 50
        let compute: (Double) -> Double = { x in
            x * 2 + 5
        }

        let result = binarySearchInput(
            min: start,
            max: end,
            current: (-500, compute(-500)),
            maxIterations: maxIterations
        ) { (input, current) in
            let next = compute(input)

            if next.magnitude < 1e-10 {
                return nil
            }

            return next
        }

        XCTAssertEqual(result, -2.5, accuracy: 1e10)
    }

    func testBinarySearchInput_returnsIfCurrentIsReturned() {
        let start: Double = -500
        let end: Double = 800
        let maxIterations = 50

        var calls = 0

        let result = binarySearchInput(
            min: start,
            max: end,
            current: (-500, -500),
            maxIterations: maxIterations
        ) { (_, current) in
            calls += 1
            return current
        }

        XCTAssertEqual(calls, 1)
        XCTAssertEqual(result, -500, accuracy: 1e-15)
    }

    func testBinarySearchInput_returnsIfMaxIterationsReached() {
        let start: Double = -500
        let end: Double = 800
        let maxIterations = 5

        var calls = 0

        _=binarySearchInput(
            min: start,
            max: end,
            current: (0, -500),
            maxIterations: maxIterations
        ) { (input, _) -> Double in
            calls += 1
            return input + 1 // Always increasing
        }

        XCTAssertEqual(calls, maxIterations)
    }
}
