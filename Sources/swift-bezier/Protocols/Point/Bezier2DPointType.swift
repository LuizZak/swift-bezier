/// A 2D Bézier point type.
public protocol Bezier2DPointType: BezierPointType {
    /// The X component of this point.
    var x: Scalar { get }

    /// The Y component of this point.
    var y: Scalar { get }
}
