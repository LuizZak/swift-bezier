import XCTest

@testable import SwiftBezier

class LookUpTableTests: XCTestCase {
    // 'System-under-test' typealias for the object we are going to test.
    typealias Sut = LookUpTable<Double, Int>

    // MARK: closestEntry(to:)

    func testClosestEntry_emptyTable() {
        let sut = makeEmptyTable()

        XCTAssertNil(sut.closestEntry(to: 0.0))
        XCTAssertNil(sut.closestEntry(to: 1.0))
    }

    func testClosestEntry_inRangeInputs() {
        let sut = makePowersOf2LookupTable()

        assertEquals(sut.closestEntry(to: 0.0), (0.0, 1))
        assertEquals(sut.closestEntry(to: 0.4), (0.0, 1))
        assertEquals(sut.closestEntry(to: 0.6), (1.0, 2))
        assertEquals(sut.closestEntry(to: 1.6), (2.0, 4))
        assertEquals(sut.closestEntry(to: 3.0), (3.0, 8))
    }

    func testClosestEntry_outOfRangeInputs() {
        let sut = makePowersOf2LookupTable()

        assertEquals(sut.closestEntry(to: -1.0), (0.0, 1))
        assertEquals(sut.closestEntry(to: 3.1), (3.0, 8))
        assertEquals(sut.closestEntry(to: 10.0), (3.0, 8))
    }

    // MARK: closestOutput(to:)

    func testClosestOutput_emptyTable() {
        let sut = makeEmptyTable()

        XCTAssertNil(sut.closestOutput(to: 0.0))
        XCTAssertNil(sut.closestOutput(to: 1.0))
    }

    func testClosestOutput_inRangeInputs() {
        let sut = makePowersOf2LookupTable()

        XCTAssertEqual(sut.closestOutput(to: 0.0), 1)
        XCTAssertEqual(sut.closestOutput(to: 0.4), 1)
        XCTAssertEqual(sut.closestOutput(to: 0.6), 2)
        XCTAssertEqual(sut.closestOutput(to: 1.6), 4)
        XCTAssertEqual(sut.closestOutput(to: 3.0), 8)
    }

    func testClosestOutput_outOfRangeInputs() {
        let sut = makePowersOf2LookupTable()

        XCTAssertEqual(sut.closestOutput(to: -1.0), 1)
        XCTAssertEqual(sut.closestOutput(to: 3.1), 8)
        XCTAssertEqual(sut.closestOutput(to: 10.0), 8)
    }

    // MARK: closestInputIndex(to:)

    func testClosesInputIndex_emptyTable() {
        let sut = makeEmptyTable()

        XCTAssertNil(sut.closestInputIndex(to: 0.0))
        XCTAssertNil(sut.closestInputIndex(to: 1.0))
    }

    func testClosestInputIndex_inRangeInputs() {
        let sut = makePowersOf2LookupTable()

        XCTAssertEqual(sut.closestInputIndex(to: 0.0), 0)
        XCTAssertEqual(sut.closestInputIndex(to: 0.4), 0)
        XCTAssertEqual(sut.closestInputIndex(to: 0.6), 1)
        XCTAssertEqual(sut.closestInputIndex(to: 1.6), 2)
        XCTAssertEqual(sut.closestInputIndex(to: 3.0), 3)
    }

    func testClosestInputIndex_outOfRangeInputs() {
        let sut = makePowersOf2LookupTable()

        XCTAssertEqual(sut.closestInputIndex(to: -1.0), 0)
        XCTAssertEqual(sut.closestInputIndex(to: 3.1), 3)
        XCTAssertEqual(sut.closestInputIndex(to: 10.0), 3)
    }

    // MARK: - Test internals

    private func makePowersOf2LookupTable(length: Int = 4) -> Sut {
        assert(length >= 0)

        return .init(table: (0..<length).map { index in
            (Double(index), 1 << index)
        })
    }

    private func makeEmptyTable() -> Sut {
        .init(table: [])
    }

    private func assertEquals<T: Equatable, U: Equatable>(
        _ lhs: (T, U)?,
        _ rhs: (T, U)?,
        file: StaticString = #file,
        line: UInt = #line
    ) {

        switch (lhs, rhs) {
        case (nil, nil):
            return
        case (let lhs?, let rhs?) where lhs == rhs:
            return
        default:
            break
        }

        XCTFail(
            #"assertEquals() failed: ("\#(lhs as Any)") is not equal to ("\#(rhs as Any)")"#,
            file: file,
            line: line
        )
    }
}
