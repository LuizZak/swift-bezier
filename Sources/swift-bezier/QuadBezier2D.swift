/// A 2D quadratic Bézier curve type.
public typealias QuadBezier2D<Point: Bezier2DPointType> = QuadBezier<Point>

extension QuadBezier2D: Bounded2DBezierType {
    @inlinable
    public func boundingRegion() -> (minimum: Output, maximum: Output) {
        let a: Output = coefficients.a * 3
        let b: Output = coefficients.b * 2
        let c: Output = coefficients.c

        var minimal = Output.pointwiseMin(p0, p1)
        var maximal = Output.pointwiseMax(p0, p1)

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

        let (t0x, t1x) = QuadraticSolver.solve(a: a.x, b: b.x, c: c.x) ?? (-1, -1)
        let (t0y, t1y) = QuadraticSolver.solve(a: a.y, b: b.y, c: c.y) ?? (-1, -1)

        update(at: t0x)
        update(at: t1x)
        update(at: t0y)
        update(at: t1y)

        return (minimal, maximal)
    }
}
