/// A quadratic Bézier curve of degree 2.
public struct QuadBezier<Output: BezierPointType>: DeCasteljauSolvableBezierType, CustomStringConvertible {
    public typealias Input = Output.Scalar

    /// The first point of this Bézier, or its starting point.
    public let p0: Output

    /// The second point of this Bézier, or its first control point.
    public let p1: Output

    /// The third point of this Bézier, or its end point.
    public let p2: Output

    /// The number of points in this quadratic Bézier curve; always `3`.
    @_transparent
    public var pointCount: Int { 3 }

    /// Returns the point at a specified point index.
    /// - precondition: `pointIndex >= 0 && pointIndex < pointCount`.
    @inlinable
    public subscript(pointIndex: Int) -> Output {
        switch pointIndex {
        case 0:
            return p0
        case 1:
            return p1
        case 2:
            return p2
        default:
            fatalError("Cannot index a \(type(of: self)) with an index of \(pointIndex).")
        }
    }

    public var points: [Output] {
        [p0, p1, p2]
    }

    public var description: String {
        "\(type(of: self))(p0: \(p0), p1: \(p1), p2: \(p2))"
    }

    /// Initializes a quadratic Bézier curve with a set of three control points.
    @inlinable
    public init(p0: Output, p1: Output, p2: Output) {
        self.p0 = p0
        self.p1 = p1
        self.p2 = p2
    }

    /// Requests that a new output value be computed at a specified input.
    @inlinable
    public func solveDeCasteljau(at input: Double) -> Output {
        let pp0 = p0.lerp(to: p1, factor: input)
        let pp1 = p1.lerp(to: p2, factor: input)

        return pp0.lerp(to: pp1, factor: input)
    }

    /// Splits this quadratic Bézier curve into two curves that overlap this curve,
    /// splitting it along a specified input point.
    @inlinable
    public func split(at input: Double) -> (left: Self, right: Self) {
        let pp0 = p0.lerp(to: p1, factor: input)
        let pp1 = p1.lerp(to: p2, factor: input)

        let p = pp0.lerp(to: pp1, factor: input)

        return (
            left: QuadBezier(
                p0: p0,
                p1: pp0,
                p2: p
            ),
            right: QuadBezier(
                p0: p,
                p1: pp1,
                p2: p2
            )
        )
    }

    /// Requests that a new output value be computed at a specified input using
    /// the fastest implementation mode available for this type.
    @inlinable
    public func compute(at input: Input) -> Output {
        let t = input
        let m_t = (1 - t)
        let t2 = t * t
        let m_t2 = m_t * m_t

        let a = m_t2 * p0
        let b = 2 * t * m_t * p1
        let c = t2 * p2

        return a + b + c
    }
}

extension QuadBezier: Equatable where Output: Equatable { }
extension QuadBezier: Hashable where Output: Hashable { }

extension QuadBezier: DerivableBezierType {
    public typealias DerivativeBezier = LinearBezier<Output>

    /// Returns a linear Bézier curve that is the derivative for this quadratic
    /// Bézier curve.
    public func derivate() -> DerivativeBezier {
        let points = deriveBezier(self)
        assert(points.count == 2, "Expected deriveBezier(_:) to return 2 points for the derivative of a \(type(of: self))")

        return .init(p0: points[0], p1: points[1])
    }
}
