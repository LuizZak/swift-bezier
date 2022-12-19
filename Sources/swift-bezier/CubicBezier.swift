/// A cubic Bézier type.
public struct CubicBezier<Output: BezierPointType>: DeCasteljauSolvableBezierType {
    public typealias Input = Output.Scalar

    /// Pre-computed internal polynomial coefficients.
    @usableFromInline
    internal let coefficients: PolynomialCoefficients

    /// The first point of this Bézier, or its starting point.
    public let p0: Output

    /// The second point of this Bézier, or its first control point.
    public let p1: Output

    /// The third point of this Bézier, or its second control point.
    public let p2: Output

    /// The fourth point of this Bézier, or its end point.
    public let p3: Output

    /// The number of points in this cubic Bézier curve; always `4`.
    @_transparent
    public var pointCount: Int { 4 }

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
        case 3:
            return p3
        default:
            fatalError("Cannot index a \(type(of: self)) with an index of \(pointIndex).")
        }
    }

    /// Initializes a cubic Bézier curve with a set of four control points.
    @inlinable
    public init(p0: Output, p1: Output, p2: Output, p3: Output) {
        self.p0 = p0
        self.p1 = p1
        self.p2 = p2
        self.p3 = p3

        self.coefficients = .init(fromP0: p0, p1: p1, p2: p2, p3: p3)
    }

    /// Requests that a new output value be computed at a specified input.
    @inlinable
    public func solveDeCasteljau(at input: Double) -> Output {
        let pp0 = p0.lerp(to: p1, factor: input)
        let pp1 = p1.lerp(to: p2, factor: input)
        let pp2 = p2.lerp(to: p3, factor: input)

        let ppp0 = pp0.lerp(to: pp1, factor: input)
        let ppp1 = pp1.lerp(to: pp2, factor: input)

        return ppp0.lerp(to: ppp1, factor: input)
    }

    /// Requests that a new output value be computed at a specified input using
    /// the fastest implementation mode available for this type.
    @inlinable
    public func compute(at input: Input) -> Output {
        let t = input
        let t2 = t * t
        let t3 = t2 * t

        let result: Output =
            p0 +
            (coefficients.c * t) +
            (coefficients.b * t2) +
            (coefficients.a * t3)

        return result
    }

    /// Describes the polynomial coefficients for this Bézier curve.
    @usableFromInline
    struct PolynomialCoefficients {
        /// `a` coefficient, or `-P₀ + 3P₁ - 3P₂ + P₃`.
        @usableFromInline
        var a: Output
        
        /// `b` coefficient, or `3P₀ - 6P₁ + 3P₂`.
        @usableFromInline
        var b: Output

        /// `c` coefficient, or `-3P₀ + 3P₁`.
        @usableFromInline
        var c: Output

        @inlinable
        init(fromP0 p0: Output, p1: Output, p2: Output, p3: Output) {
            a = (-p0) as Output + (3 * p1) as Output - (3 * p2) as Output + p3
            b = (3 * p0) as Output - (6 * p1) as Output + (3 * p2) as Output
            c = (-3 * p0) as Output + (3 * p1) as Output
        }
    }
}
