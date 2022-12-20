import XCTest

@testable import SwiftBezier

class CachedBezierTests: XCTestCase {
    typealias Bezier = CubicBezier2<Bezier2DPoint>

    var testProxy: BoundedProxyTestBezier<Bezier>!
    var sut: CachedBezier<BoundedProxyTestBezier<Bezier>>!

    override func setUp() {
        testProxy = .init(bezier: .makeZigZagBezier())
        sut = .init(bezier: testProxy)
    }

    func testCache_computeSeries() {
        XCTAssertEqual(testProxy.computeSeriesSteps_calls, []) // Pre-test sanity check

        _=sut.computeSeries(steps: 10)
        XCTAssertEqual(testProxy.computeSeriesSteps_calls, [
            10
        ])

        _=sut.computeSeries(steps: 10)
        _=sut.computeSeries(steps: 11)
        _=sut.computeSeries(steps: 10)
        XCTAssertEqual(testProxy.computeSeriesSteps_calls, [
            10, 11
        ])

        _=sut.computeSeries(steps: 11)
        XCTAssertEqual(testProxy.computeSeriesSteps_calls, [
            10, 11
        ])
    }

    func testCache_createLookupTable() {
        XCTAssertEqual(testProxy.createLookupTable_calls, []) // Pre-test sanity check

        _=sut.createLookupTable(steps: 10)
        XCTAssertEqual(testProxy.createLookupTable_calls, [
            10
        ])
        
        _=sut.createLookupTable(steps: 10)
        _=sut.createLookupTable(steps: 11)
        _=sut.createLookupTable(steps: 10)
        XCTAssertEqual(testProxy.createLookupTable_calls, [
            10, 11
        ])

        _=sut.createLookupTable(steps: 11)
        XCTAssertEqual(testProxy.createLookupTable_calls, [
            10, 11
        ])
    }

    func testCache_boundingRegion() {
        XCTAssertEqual(testProxy.boundingRegion_calls.count, 0) // Pre-test sanity check

        _=sut.boundingRegion()
        XCTAssertEqual(testProxy.boundingRegion_calls.count, 1)

        _=sut.boundingRegion()
        _=sut.boundingRegion()
        XCTAssertEqual(testProxy.boundingRegion_calls.count, 1)
    }

    func testFlushCachedValues() {
        func fillCache() {
            _=sut.boundingRegion()
            _=sut.computeSeries(steps: 10)
            _=sut.createLookupTable(steps: 11)
        }
        
        fillCache()

        sut.flushCachedValues()

        fillCache()
        
        XCTAssertEqual(testProxy.boundingRegion_calls.count, 2)
        XCTAssertEqual(testProxy.computeSeriesSteps_calls, [
            10, 10,
        ])
        XCTAssertEqual(testProxy.createLookupTable_calls, [
            11, 11,
        ])
    }
}
