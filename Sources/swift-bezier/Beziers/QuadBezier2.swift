/// A 2-dimensional cubic Bézier curve type.
public typealias QuadBezier2<Point: Bezier2PointType> = QuadBezier<Point>

extension QuadBezier2: Bounded2BezierType {
    @inlinable
    public func boundingRegion() -> (minimum: Output, maximum: Output) {
        typealias Scalar = Output.Scalar

        var minimal = Output.pointwiseMin(p0, p2)
        var maximal = Output.pointwiseMax(p0, p2)

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

        let derived = derive([p0, p1, p2])

        let a = derived[0]
        let b = derived[1]

        let dividend = b - a

        if dividend.x != 0 {
            let t = -a.x / dividend.x

            update(at: t)
        }
        if dividend.y != 0 {
            let t = -a.y / dividend.y

            update(at: t)
        }

        return (minimal, maximal)
    }
}
