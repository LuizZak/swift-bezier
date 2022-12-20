import XCTest
import SwiftBezier
import Numerics

// MARK: Bézier assertions

@discardableResult
func assertEquals<Bezier: BezierType>(
    _ v1: Bezier,
    _ v2: Bezier,
    message: @autoclosure () -> String = "",
    file: StaticString = #file,
    line: UInt = #line
) -> Bool {

    guard assertEquals(v1.pointCount, v2.pointCount, message: "Béziers have different point counts.", file: file, line: line) else {
        return false
    }

    for i in 0..<v1.pointCount {
        let p1 = v1[i]
        let p2 = v2[i]

        if !assertEquals(p1, p2, message: "Béziers have different point @ index \(i)", file: file, line: line) {
            return false
        }
    }

    return true
}

@discardableResult
func assertEquals<Bezier: BezierType>(
    _ v1: Bezier,
    _ v2: Bezier,
    accuracy: Bezier.Output.Scalar,
    message: @autoclosure () -> String = "",
    file: StaticString = #file,
    line: UInt = #line
) -> Bool where Bezier.Output: Bezier2PointType {

    guard assertEquals(v1.pointCount, v2.pointCount, message: "Béziers have different point counts.", file: file, line: line) else {
        return false
    }

    for i in 0..<v1.pointCount {
        let p1 = v1[i]
        let p2 = v2[i]

        if !assertEquals(p1, p2, accuracy: accuracy, message: "Béziers have different point @ index \(i)", file: file, line: line) {
            return false
        }
    }

    return true
}


// MARK: - Point assertions

@discardableResult
func assertEquals<Point: Bezier2PointType>(
    _ v1: Point,
    _ v2: Point,
    accuracy: Point.Scalar? = nil,
    message: @autoclosure () -> String = "",
    file: StaticString = #file,
    line: UInt = #line
) -> Bool {

    return assertEquals(v1.x, v2.x, accuracy: accuracy, message: "x", file: file, line: line)
        && assertEquals(v1.y, v2.y, accuracy: accuracy, message: "y", file: file, line: line)
}

// MARK: - General assertions

@discardableResult
func assertEquals<T: FloatingPoint>(
    _ v1: T,
    _ v2: T,
    accuracy: T.Magnitude? = nil,
    message: @autoclosure () -> String = "",
    file: StaticString = #file,
    line: UInt = #line
) -> Bool {

    if let accuracy = accuracy {
        if !v1.isApproximatelyEqual(to: v2, absoluteTolerance: accuracy) {
            return assertFailed(
                message: #"assertEquals() failed: ("\#(v1)") != ("\#(v2)") with accuracy \#(accuracy) \#(message())"#,
                file: file,
                line: line
            )
        }

        return true
    } else {
        if v1 != v2 {
            return assertFailed(
                message: #"assertEquals() failed: ("\#(v1)") != ("\#(v2)") \#(message())"#,
                file: file,
                line: line
            )
        }

        return true
    }
}

@discardableResult
func assertEquals<T: Equatable>(
    _ v1: T,
    _ v2: T,
    message: @autoclosure () -> String = "",
    file: StaticString = #file,
    line: UInt = #line
) -> Bool {

    if v1 != v2 {
        return assertFailed(
            message: #"assertEquals() failed: ("\#(v1)") != ("\#(v2)") \#(message())"#,
            file: file,
            line: line
        )
    }

    return true
}

@discardableResult
func assertFailed(
    message: @autoclosure () -> String = "",
    file: StaticString = #file,
    line: UInt = #line
) -> Bool {

    XCTFail(
        message(),
        file: file,
        line: line
    )

    return false
}
