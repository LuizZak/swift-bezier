/// A protocol for points in Bézier curves.
public protocol BezierPointType: Equatable, AdditiveArithmetic {
    /// The scalar type for this Bézier point.
    associatedtype Scalar: Comparable, FloatingPoint

    /// Linearly interpolates between `self` and `factor`.
    func lerp(to end: Self, factor: Double) -> Self

    /// Negates the value of this point.
    static prefix func - (value: Self) -> Self

    /// Standard point-wise multiplication operation.
    static func * (lhs: Self, rhs: Self) -> Self
    
    /// Standard point-wise division operation.
    static func / (lhs: Self, rhs: Self) -> Self

    /// Multiplies this Bézier point type by a given scalar value.
    static func * (lhs: Self, rhs: Scalar) -> Self

    /// Multiplies this Bézier point type by a given scalar value.
    static func * (lhs: Scalar, rhs: Self) -> Self
    
    /// Divides this Bézier point type by a given scalar value.
    static func / (lhs: Self, rhs: Scalar) -> Self

    /// Returns a new point type where each component is the minimal component
    /// between `v1` and `v2`.
    static func pointwiseMin(_ v1: Self, _ v2: Self) -> Self

    /// Returns a new point type where each component is the maximal component
    /// between `v1` and `v2`.
    static func pointwiseMax(_ v1: Self, _ v2: Self) -> Self
}
