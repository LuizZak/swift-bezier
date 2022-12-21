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
}
