import XCTest
import MiniP5Printer

@testable import SwiftBezier

class TestFixture {
    private var hasFailures: Bool = false
    private var p5Printer: P5Printer

    private convenience init(
        size: PVector2i = .init(x: 800, y: 600),
        lineScale: Double = 2.0,
        renderScale: Double = 1.0
    ) {
        self.init(
            p5Printer: .init(
                size: size,
                lineScale: lineScale,
                renderScale: renderScale
            )
        )
    }

    private init(p5Printer: P5Printer) {
        self.p5Printer = p5Printer
    }

    private func finish() {
        guard hasFailures else {
            return
        }

        p5Printer.printAll()
    }

    static func beginFixture(
        size: PVector2i = .init(x: 800, y: 600),
        lineScale: Double = 2.0,
        renderScale: Double = 1.0,
        _ block: (TestFixture) -> Void
    ) {
        let fixture = TestFixture(size: size, lineScale: lineScale, renderScale: renderScale)
        defer { fixture.finish() }

        block(fixture)
    }

    class Asserter<T> {
        fileprivate var hasEmitted: Bool = false
        fileprivate let value: T
        fileprivate let fixture: TestFixture
        fileprivate let file: StaticString, line: UInt
        fileprivate var p5Printer: P5Printer {
            fixture.p5Printer
        }

        fileprivate init(
            value: T,
            fixture: TestFixture,
            file: StaticString,
            line: UInt
        ) {
            self.value = value
            self.fixture = fixture
            self.file = file
            self.line = line
        }

        func printOnce(_ emitter: (P5Printer) -> Void) {
            guard !hasEmitted else { return }
            hasEmitted = true

            emitter(p5Printer)
        }
    }
}

extension TestFixture {
    func add<Bezier: BezierType>(
        bezier: Bezier,
        file: StaticString = #file,
        line: UInt = #line
    ) where Bezier.Output: Bezier2PointType {
        p5Printer.add(
            bezier: bezier,
            file: file,
            line: line
        )
    }

    func add<Point: Bezier2PointType>(
        point: Point,
        file: StaticString = #file,
        line: UInt = #line
    ) {
        p5Printer.add(
            point,
            file: file,
            line: line
        )
    }

    func asserter<T>(_ object: T, file: StaticString = #file, line: UInt = #line) -> Asserter<T> {
        .init(value: object, fixture: self, file: file, line: line)
    }
}

extension TestFixture.Asserter {
    func assertEquals(
        _ expected: T,
        file: StaticString = #file,
        line: UInt = #line
    ) where T: Equatable {

        guard value != expected else { return }
        fixture.hasFailures = true

        SwiftBezierTests.assertEquals(value, expected, file: file, line: line)
    }

    func assertEquals(
        _ expected: T,
        by comparer: (T, T) -> Bool,
        file: StaticString = #file,
        line: UInt = #line
    ) {

        guard !comparer(value, expected) else { return }
        fixture.hasFailures = true

        XCTFail("\(value) != \(expected)", file: file, line: line)
    }

    func assertBezierEquals(
        _ expected: T,
        file: StaticString = #file,
        line: UInt = #line
    ) where T: BezierType & Equatable {

        guard value != expected else { return }
        fixture.hasFailures = true

        SwiftBezierTests.assertBezierEquals(value, expected, file: file, line: line)
    }

    func assertBezierEquals(
        _ expected: T,
        file: StaticString = #file,
        line: UInt = #line
    ) where T: BezierType & Equatable, T.Output: Bezier2PointType {

        guard value != expected else { return }
        fixture.hasFailures = true

        SwiftBezierTests.assertBezierEquals(value, expected, file: file, line: line)
        p5Printer.add(bezier: expected, style: p5Printer.styling.expected, file: file, line: line)

        printOnce { $0.add(bezier: value, style: p5Printer.styling.actual, file: self.file, line: self.line) }
    }
}
