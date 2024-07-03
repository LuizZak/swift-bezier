import Foundation

/// An implementation of `ConstructibleBezier2PointType` with `Double` scalars.
public struct Bezier2DPoint: ConstructibleBezier2PointType, Hashable, CustomStringConvertible {
    public typealias Scalar = Double

    /// Returns the zero point, or `(0.0, 0.0)`.
    public static let zero = Bezier2DPoint(x: 0.0, y: 0.0)

    public var x: Scalar
    public var y: Scalar

    public var description: String {
        "\(type(of: self))(x: \(x), y: \(y))"
    }

    /// Creates a new 2-dimensional Bézier point with the specified coordinates.
    @inlinable
    public init(x: Scalar, y: Scalar) {
        self.x = x
        self.y = y
    }

    /// Creates a new 2-dimensional Bézier point with the specified value for
    /// both coordinates.
    @inlinable
    public init(repeating scalar: Scalar) {
        self.x = scalar
        self.y = scalar
    }
}

extension Bezier2DPoint {
    @inlinable
    public func lerp(to end: Self, factor: Double) -> Self {
        self * (1 - factor) + end * factor
    }

    @inlinable
    public func dot(_ other: Self) -> Scalar {
        x * other.x + y * other.y
    }

    @inlinable
    public func leftRotated() -> Self {
        Self(x: -y, y: x)
    }

    @inlinable
    public func rightRotated() -> Self {
        Self(x: y, y: -x)
    }

    @inlinable
    public func angle() -> Scalar {
        atan2(y, x)
    }

    @inlinable
    public func rotated(by angleInRadians: Scalar) -> Self {
        let c = cos(angleInRadians)
        let s = sin(angleInRadians)

        return Self(x: (c * x) - (s * y), y: (s * x) + (c * y))
    }

    public func transposed(along line: LinearBezier2<Self>) -> Self {
        (line.p0 - self).rotated(by: -(line.p0 - line.p1).angle())
    }

    @inlinable
    public static prefix func - (value: Self) -> Self {
        .init(x: -value.x, y: -value.y)
    }

    @inlinable
    public static func + (lhs: Self, rhs: Self) -> Self {
        .init(x: lhs.x + rhs.x, y: lhs.y + rhs.y)
    }

    @inlinable
    public static func - (lhs: Self, rhs: Self) -> Self {
        .init(x: lhs.x - rhs.x, y: lhs.y - rhs.y)
    }

    @inlinable
    public static func * (lhs: Self, rhs: Self) -> Self {
        .init(x: lhs.x * rhs.x, y: lhs.y * rhs.y)
    }

    @inlinable
    public static func / (lhs: Self, rhs: Self) -> Self {
        .init(x: lhs.x / rhs.x, y: lhs.y / rhs.y)
    }

    @inlinable
    public static func * (lhs: Self, rhs: Scalar) -> Self {
        lhs * .init(repeating: rhs)
    }

    @inlinable
    public static func * (lhs: Scalar, rhs: Self) -> Self {
        .init(repeating: lhs) * rhs
    }

    @inlinable
    public static func / (lhs: Self, rhs: Scalar) -> Self {
        lhs / .init(repeating: rhs)
    }

    @inlinable
    public static func >= (lhs: Self, rhs: Self) -> Bool {
        lhs.x >= rhs.x && lhs.y >= rhs.y
    }

    @inlinable
    public static func > (lhs: Self, rhs: Self) -> Bool {
        lhs.x > rhs.x && lhs.y > rhs.y
    }

    @inlinable
    public static func < (lhs: Self, rhs: Self) -> Bool {
        lhs.x < rhs.x && lhs.y < rhs.y
    }

    @inlinable
    public static func <= (lhs: Self, rhs: Self) -> Bool {
        lhs.x <= rhs.x && lhs.y <= rhs.y
    }

    @inlinable
    public static func pointwiseMin(_ v1: Self, _ v2: Self) -> Self {
        .init(x: min(v1.x, v2.x), y: min(v1.y, v2.y))
    }

    @inlinable
    public static func pointwiseMax(_ v1: Self, _ v2: Self) -> Self {
        .init(x: max(v1.x, v2.x), y: max(v1.y, v2.y))
    }
}
