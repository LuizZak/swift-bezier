import XCTest

@testable import SwiftBezier

class CubicBezier2DTests: XCTestCase {
    // 'System-under-test' typealias for the object we are going to test.
    typealias Sut = CubicBezier2<Bezier2DPoint>

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
}
