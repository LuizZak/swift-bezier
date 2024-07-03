import XCTest

@testable import SwiftBezier

class Bezier2DPointTests: XCTestCase {
    typealias Sut = Bezier2DPoint

    func testTransposed() {
        let sut = Sut(x: 10, y: 15)
        let line = LinearBezier2D(p0: .init(x: 10, y: 20), p1: .init(x: 15, y: 16))

        let result = sut.transposed(along: line)

        assertEquals(
            result,
            .init(x: -3.1234752377721215, y: -3.904344047215152)
        )
    }

    func testTransposed_originLine() {
        let sut = Sut(x: 10, y: 15)
        let line = LinearBezier2D(p0: .init(x: 0, y: 0), p1: .init(x: 20, y: 0))

        let result = sut.transposed(along: line)

        assertEquals(result, sut)
    }
}
