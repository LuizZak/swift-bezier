/// A 2-dimensional cubic Bézier curve type.
public typealias CubicBezier2<Point: Bezier2PointType> = CubicBezier<Point>

extension CubicBezier2: Bounded2BezierType {
    @inlinable
    public func boundingRegion() -> (minimum: Output, maximum: Output) {
        typealias Scalar = Output.Scalar

        // a = -3P₀ + 9P₁ - 9P₂ + 3P₃
        let a: Output = coefficients.a * 3
        // b = 6P₀ - 12P₁ + 6P₂
        let b: Output = coefficients.b * 2
        // c = -3P₀ + 3P₁
        let c: Output = coefficients.c

        var minimal = Output.pointwiseMin(p0, p3)
        var maximal = Output.pointwiseMax(p0, p3)

        func inRange(_ t: Input) -> Bool {
            t >= 0 && t <= 1
        }
        func update(_ p: Output) {
            minimal = Output.pointwiseMin(minimal, p)
            maximal = Output.pointwiseMax(maximal, p)
        }
        func update(at t: Input) {
            guard inRange(t) else {
                return
            }

            update(compute(at: t))
        }

        if a.x != 0 {
            // Quadratic
            let (t0x, t1x) = QuadraticSolver.solve(a: a.x, b: b.x, c: c.x) ?? (-1, -1)
            update(at: t0x)
            update(at: t1x)
        } else if b.x != 0 {
            // Linear
            let tx = -c.x / b.x
            update(at: tx)
        } else {
            // Constant?
            update(at: -c.x)
        }

        if a.y != 0 {
            // Quadratic
            let (t0y, t1y) = QuadraticSolver.solve(a: a.y, b: b.y, c: c.y) ?? (-1, -1)
            update(at: t0y)
            update(at: t1y)
        } else if b.y != 0 {
            // Linear
            let ty = -c.y / b.y
            update(at: ty)
        } else {
            // Constant?
            update(at: -c.y)
        }

        return (minimal, maximal)
    }
}
