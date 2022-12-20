import XCTest

@testable import SwiftBezier

class QuadBezier2Tests: XCTestCase {
    // 'System-under-test' typealias for the object we are going to test.
    typealias Sut = QuadBezier2<Bezier2DPoint>

    func testBoundingRegion_waveCuspBezier() {
        let sut = Sut.makeWaveCusp()

        let (minimum, maximum) = sut.boundingRegion()

        XCTAssertEqual(minimum, .init(x: 66.15384615384615, y: 60.0))
        XCTAssertEqual(maximum, .init(x: 220.0, y: 250.0))
    }
}
