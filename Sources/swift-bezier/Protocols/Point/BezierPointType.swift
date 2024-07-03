/// A protocol for points in Bézier curves.
public protocol BezierPointType: Equatable, AdditiveArithmetic {
    /// The scalar type for this Bézier point.
    associatedtype Scalar: Comparable, FloatingPoint

    /// Gets the magnitude of this Bézier point, or its absolute length from
    /// origin.
    var magnitude: Scalar { get }

    /// Gets the magnitude squared of this Bézier point, or its absolute length
    /// from origin squared.
    var magnitudeSquared: Scalar { get }

    /// Linearly interpolates between `self` and `end` by a given factor.
    func lerp(to end: Self, factor: Double) -> Self

    /// Returns the distance squared from this point to another.
    func distanceSquared(to other: Self) -> Scalar

    /// Returns the distance from this point to another.
    func distance(to other: Self) -> Scalar

    /// Returns the dot product of this Bézier point with another point.
    func dot(_ other: Self) -> Scalar

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

extension BezierPointType {
    @inlinable
    public var magnitude: Scalar {
        self.dot(self).squareRoot()
    }

    @inlinable
    public var magnitudeSquared: Scalar {
        self.dot(self)
    }

    @inlinable
    public func distanceSquared(to other: Self) -> Scalar {
        let d = (self - other)

        return d.magnitudeSquared
    }

    @inlinable
    public func distance(to other: Self) -> Scalar {
        distanceSquared(to: other).squareRoot()
    }
}
