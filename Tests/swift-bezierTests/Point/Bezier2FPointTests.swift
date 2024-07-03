import XCTest

@testable import SwiftBezier

class Bezier2FPointTests: XCTestCase {
    typealias Sut = Bezier2FPoint

    func testTransposed() {
        let sut = Sut(x: 10, y: 15)
        let line = LinearBezier2F(p0: .init(x: 10, y: 20), p1: .init(x: 15, y: 16))

        let result = sut.transposed(along: line)

        assertEquals(
            result,
            .init(x: -3.1234753, y: -3.9043438)
        )
    }

    func testTransposed_originLine() {
        let sut = Sut(x: 10, y: 15)
        let line = LinearBezier2F(p0: .init(x: 0, y: 0), p1: .init(x: 20, y: 0))

        let result = sut.transposed(along: line)

        assertEquals(result, sut)
    }
}
