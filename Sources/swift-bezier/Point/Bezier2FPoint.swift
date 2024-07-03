import Foundation

/// An implementation of `ConstructibleBezier2PointType` with `Float` scalars.
public struct Bezier2FPoint: ConstructibleBezier2PointType, Hashable, CustomStringConvertible {
    public typealias Scalar = Float

    /// Returns the zero point, or `(0.0, 0.0)`.
    public static let zero = Bezier2FPoint(x: 0.0, y: 0.0)

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

extension Bezier2FPoint {
    @inlinable
    public func lerp(to end: Bezier2FPoint, factor: Double) -> Bezier2FPoint {
        self * Scalar(1 - factor) + end * Scalar(factor)
    }

    @inlinable
    public func dot(_ other: Bezier2FPoint) -> Scalar {
        x * other.x + y * other.y
    }

    @inlinable
    public func rotated(by angleInRadians: Scalar) -> Self {
        let c = cos(angleInRadians)
        let s = sin(angleInRadians)

        return Self(x: (c * x) - (s * y), y: (s * x) + (c * y))
    }

    @inlinable
    public static prefix func - (value: Bezier2FPoint) -> Bezier2FPoint {
        .init(x: -value.x, y: -value.y)
    }

    @inlinable
    public static func * (lhs: Bezier2FPoint, rhs: Bezier2FPoint) -> Bezier2FPoint {
        .init(x: lhs.x * rhs.x, y: lhs.y * rhs.y)
    }

    @inlinable
    public static func / (lhs: Bezier2FPoint, rhs: Bezier2FPoint) -> Bezier2FPoint {
        .init(x: lhs.x / rhs.x, y: lhs.y / rhs.y)
    }

    @inlinable
    public static func * (lhs: Bezier2FPoint, rhs: Scalar) -> Bezier2FPoint {
        lhs * .init(repeating: rhs)
    }

    @inlinable
    public static func * (lhs: Scalar, rhs: Bezier2FPoint) -> Bezier2FPoint {
        .init(repeating: lhs) * rhs
    }

    @inlinable
    public static func / (lhs: Bezier2FPoint, rhs: Scalar) -> Bezier2FPoint {
        lhs / .init(repeating: rhs)
    }

    @inlinable
    public static func + (lhs: Bezier2FPoint, rhs: Bezier2FPoint) -> Bezier2FPoint {
        .init(x: lhs.x + rhs.x, y: lhs.y + rhs.y)
    }

    @inlinable
    public static func - (lhs: Bezier2FPoint, rhs: Bezier2FPoint) -> Bezier2FPoint {
        .init(x: lhs.x - rhs.x, y: lhs.y - rhs.y)
    }

    @inlinable
    public static func pointwiseMin(_ v1: Bezier2FPoint, _ v2: Bezier2FPoint) -> Bezier2FPoint {
        .init(x: min(v1.x, v2.x), y: min(v1.y, v2.y))
    }

    @inlinable
    public static func pointwiseMax(_ v1: Bezier2FPoint, _ v2: Bezier2FPoint) -> Bezier2FPoint {
        .init(x: max(v1.x, v2.x), y: max(v1.y, v2.y))
    }
}
