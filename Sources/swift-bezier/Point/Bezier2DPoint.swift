/// An implementation of `Bezier2PointType` with `Double` scalars.
public struct Bezier2DPoint: Bezier2PointType, Hashable, CustomStringConvertible {
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
    public func lerp(to end: Bezier2DPoint, factor: Double) -> Bezier2DPoint {
        self * (1 - factor) + end * factor
    }

    public func dot(_ other: Bezier2DPoint) -> Scalar {
        x * other.x + y * other.y
    }

    @inlinable
    public static prefix func - (value: Bezier2DPoint) -> Bezier2DPoint {
        .init(x: -value.x, y: -value.y)
    }

    @inlinable
    public static func * (lhs: Bezier2DPoint, rhs: Bezier2DPoint) -> Bezier2DPoint {
        .init(x: lhs.x * rhs.x, y: lhs.y * rhs.y)
    }

    @inlinable
    public static func / (lhs: Bezier2DPoint, rhs: Bezier2DPoint) -> Bezier2DPoint {
        .init(x: lhs.x / rhs.x, y: lhs.y / rhs.y)
    }

    @inlinable
    public static func * (lhs: Bezier2DPoint, rhs: Scalar) -> Bezier2DPoint {
        lhs * .init(repeating: rhs)
    }

    @inlinable
    public static func * (lhs: Scalar, rhs: Bezier2DPoint) -> Bezier2DPoint {
        .init(repeating: lhs) * rhs
    }

    @inlinable
    public static func / (lhs: Bezier2DPoint, rhs: Scalar) -> Bezier2DPoint {
        lhs / .init(repeating: rhs)
    }

    @inlinable
    public static func + (lhs: Bezier2DPoint, rhs: Bezier2DPoint) -> Bezier2DPoint {
        .init(x: lhs.x + rhs.x, y: lhs.y + rhs.y)
    }

    @inlinable
    public static func - (lhs: Bezier2DPoint, rhs: Bezier2DPoint) -> Bezier2DPoint {
        .init(x: lhs.x - rhs.x, y: lhs.y - rhs.y)
    }

    @inlinable
    public static func pointwiseMin(_ v1: Bezier2DPoint, _ v2: Bezier2DPoint) -> Bezier2DPoint {
        .init(x: min(v1.x, v2.x), y: min(v1.y, v2.y))
    }

    @inlinable
    public static func pointwiseMax(_ v1: Bezier2DPoint, _ v2: Bezier2DPoint) -> Bezier2DPoint {
        .init(x: max(v1.x, v2.x), y: max(v1.y, v2.y))
    }
}
