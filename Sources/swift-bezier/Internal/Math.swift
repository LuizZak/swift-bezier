/// Returns the derivative for a given list of Bézier curve control points.
/// The resulting list is a Bézier curve of one degree less than the input points.
@inlinable
func deriveBezier<Bezier: BezierType>(_ bezier: Bezier) -> [Bezier.Output] {
    deriveBezierPoints(bezier.points)
}

/// Returns the derivative for a given list of Bézier curve control points.
/// The resulting list is a Bézier curve of one degree less than the input points.
@inlinable
func deriveBezierPoints<Point: BezierPointType>(_ points: [Point]) -> [Point] {
    guard !points.isEmpty else {
        return points
    }

    let degree = Point.Scalar(points.count - 1)
    return zip(points.dropFirst(), points).map { (pn, p) in
        degree * (pn - p)
    }
}

/// Returns a list of derivatives for a given list of Bézier curve control points,
/// with all derivatives down to degree 1.
@inlinable
func deriveAllBezierPoints<Point: BezierPointType>(_ points: [Point]) -> [[Point]] {
    var result: [[Point]] = []

    var points = points

    while points.count > 1 {
        let derivative = deriveBezierPoints(points)
        points = derivative

        result.append(derivative)
    }

    return result
}
