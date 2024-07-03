/// A 2-dimensional Bézier point type.
public protocol Bezier2PointType: BezierPointType {
    /// The X component of this point.
    var x: Scalar { get }

    /// The Y component of this point.
    var y: Scalar { get }

    /// Returns the result of rotating this vector by 90º counter-clockwise along
    /// the origin.
    func leftRotated() -> Self

    /// Returns the result of rotating this vector by 90º clockwise along the origin.
    func rightRotated() -> Self

    /// Gets the angle, in radians, of this point, as the angle between the origin
    /// and `self`.
    func angle() -> Scalar

    /// Returns the result of rotating this point around the origin by `angleInRadians`.
    func rotated(by angleInRadians: Scalar) -> Self

    /// Transposes this point such that the resulting point rests on a transformed
    /// origin line, represented by `line`.
    func transposed(along line: LinearBezier2<Self>) -> Self
}
