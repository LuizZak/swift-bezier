/// A linear Bézier curve of degree 1, or simply a line.
///
/// It is convenient mostly as the result of the derivative of a degree 2, or
/// quadratic- Bézier curve.
public struct LinearBezier<Output: BezierPointType>: DeCasteljauSolvableBezierType, CustomStringConvertible {
    public typealias Input = Output.Scalar

    /// The first point of this Bézier, or its starting point.
    public let p0: Output

    /// The second point of this Bézier, or its ending point.
    public let p1: Output

    /// The number of points in this linear Bézier curve; always `2`.
    @_transparent
    public var pointCount: Int { 2 }

    /// Returns the point at a specified point index.
    /// - precondition: `pointIndex >= 0 && pointIndex < pointCount`.
    @inlinable
    public subscript(pointIndex: Int) -> Output {
        switch pointIndex {
        case 0:
            return p0
        case 1:
            return p1
        default:
            fatalError("Cannot index a \(type(of: self)) with an index of \(pointIndex).")
        }
    }

    public var points: [Output] {
        [p0, p1]
    }

    public var description: String {
        "\(type(of: self))(p0: \(p0), p1: \(p1))"
    }

    /// Initializes a linear Bézier curve with a set of two control points.
    @inlinable
    public init(p0: Output, p1: Output) {
        self.p0 = p0
        self.p1 = p1
    }

    /// Requests that a new output value be computed at a specified input.
    @inlinable
    public func solveDeCasteljau(at input: Double) -> Output {
        return p0.lerp(to: p1, factor: input)
    }

    /// Splits this linear Bézier curve into two curves that overlap this curve,
    /// splitting it along a specified input point.
    @inlinable
    public func split(at input: Double) -> (left: Self, right: Self) {
        let p = p0.lerp(to: p1, factor: input)

        return (
            left: LinearBezier(
                p0: p0,
                p1: p
            ),
            right: LinearBezier(
                p0: p,
                p1: p1
            )
        )
    }

    /// Requests that a new output value be computed at a specified input using
    /// the fastest implementation mode available for this type.
    @inlinable
    public func compute(at input: Input) -> Output {
        p0 * (1 - input) + p1 * input
    }
}

extension LinearBezier where Input == Double {
    /// Returns the length of this linear Bézier.
    public func length() -> Input {
        p0.distance(to: p1)
    }
}
