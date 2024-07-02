/// A 2-dimensional Bézier point type that can be constructed from two axis.
public protocol ConstructibleBezier2PointType: Bezier2PointType {
    /// Constructs a new Bézier 2 point of this type, on the given coordinates.
    init(x: Scalar, y: Scalar)
}
