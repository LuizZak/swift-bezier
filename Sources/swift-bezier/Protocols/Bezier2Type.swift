/// A 2-dimensional Bézier curve type.
public protocol Bezier2Type: BezierType where Output: Bezier2PointType {
    /// Returns the result of rotating the points of this Bézier curve by
    /// `angleInRadians` around the origin.
    func rotated(by angleInRadians: Output.Scalar) -> Self

    /// Returns the result of alining this Bézier curve by translating and
    /// rotating its control points such that they are resting on the origin
    /// line, transformed along the given `line`.
    func aligned(along line: LinearBezier2<Output>) -> Self
}
