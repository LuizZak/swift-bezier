import XCTest

@testable import SwiftBezier

class LinearBezier2Tests: XCTestCase {
    // 'System-under-test' typealias for the object we are going to test.
    typealias Sut = LinearBezier2<Bezier2DPoint>

    func testBoundingRegion_waveCuspBezier() {
        let sut = Sut.makeDescendingLineBezier()

        let (minimum, maximum) = sut.boundingRegion()

        XCTAssertEqual(minimum, .init(x: 5, y: 10))
        XCTAssertEqual(maximum, .init(x: 20, y: 20))
    }

    func testRotated() {
        let sut = Sut.makeAscendingLineBezier()

        let result = sut.rotated(by: .pi / 2)

        assertBezierEquals(
            result,
            .init(
                p0: .init(x: -10.0, y: 5.000000000000001),
                p1: .init(x: -20.0, y: 20.0)
            )
        )
    }
}
