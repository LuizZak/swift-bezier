/// A 2-dimensional Bézier point type.
public protocol Bezier2PointType: BezierPointType {
    /// The X component of this point.
    var x: Scalar { get }

    /// The Y component of this point.
    var y: Scalar { get }
}
