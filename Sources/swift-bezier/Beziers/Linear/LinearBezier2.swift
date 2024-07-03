/// A 2-dimensional linear Bézier curve type.
public typealias LinearBezier2<Point: Bezier2PointType> = LinearBezier<Point>

extension LinearBezier2: Bounded2BezierType {
    /// Returns the minimal bounding region for this linear Bézier curve.
    /// It is simply the minimal axis-aligned bounding region for the two control
    /// points.
    @inlinable
    public func boundingRegion() -> (minimum: Output, maximum: Output) {
        let minimal = Output.pointwiseMin(p0, p1)
        let maximal = Output.pointwiseMax(p0, p1)

        return (minimal, maximal)
    }

    /// Returns the result of rotating the points of this Bézier curve by
    /// `angleInRadians` around the origin.
    public func rotated(by angleInRadians: Output.Scalar) -> Self {
        .init(
            p0: p0.rotated(by: angleInRadians),
            p1: p1.rotated(by: angleInRadians)
        )
    }
}
