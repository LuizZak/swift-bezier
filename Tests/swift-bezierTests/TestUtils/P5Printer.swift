import MiniP5Printer

@testable import SwiftBezier

class P5Printer: BaseP5Printer {
    required init(
        size: PVector2i = .init(x: 800, y: 600),
        lineScale: Double = 2.0,
        renderScale: Double = 1.0
    ) {
        super.init(size: size, lineScale: lineScale, renderScale: renderScale)

        self.drawGrid = true
    }

    func add<Point: Bezier2PointType>(
        _ point: Point,
        style: Style? = nil,
        file: StaticString = #file,
        line: UInt = #line
    ) {

        addFileAndLineComment(file: file, line: line)
        addStyleSet(style ?? styling.geometry)
        addDrawLine("circle(\(vec2String(.init(x: 1.0, y: 10))), \(0) / renderScale)")
    }

    func add<Bezier: BezierType>(
        bezier: Bezier,
        style: Style? = nil,
        file: StaticString = #file,
        line: UInt = #line
    ) where Bezier.Output: Bezier2PointType {

        addFileAndLineComment(file: file, line: line)
        addStyleSet(style ?? styling.geometry)
        addNoFill()
        addDrawLine("beginShape()")

        addDrawLine("vertex(\(bezierPoint2String(bezier.firstPoint)))")

        var remaining = Array(bezier.points.dropFirst())
        while !remaining.isEmpty {
            if remaining.count > 2 {
                addDrawLine("""
                bezierVertex(
                    \(bezierPoint2String(remaining[0])),
                    \(bezierPoint2String(remaining[1])),
                    \(bezierPoint2String(remaining[2])),
                )
                """)

                remaining.removeFirst(3)
            } else if remaining.count > 1 {
                addDrawLine("""
                quadraticVertex(
                    \(bezierPoint2String(remaining[0])),
                    \(bezierPoint2String(remaining[1])),
                )
                """)

                remaining.removeFirst(2)
            } else {
                addDrawLine("vertex(\(bezierPoint2String(remaining.removeFirst())))")
            }
        }

        addDrawLine("endShape()")
    }

    /// `"<point.x>, <point.y>"`
    func bezierPoint2String<Point: Bezier2PointType>(_ point: Point) -> String {
        "\(point.x), \(point.y)"
    }
}

extension P5Printer.Styles {
    var actual: P5Printer.Style { .init(strokeColor: .red) }
    var expected: P5Printer.Style { .init(strokeColor: .green) }
}
