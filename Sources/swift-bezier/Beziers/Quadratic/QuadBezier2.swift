/// A 2-dimensional cubic Bézier curve type.
public typealias QuadBezier2<Point: Bezier2PointType> = QuadBezier<Point>

extension QuadBezier2: Bezier2Type, BoundedBezier2Type {
    /// Returns the minimal bounding region for this quadratic Bézier curve.
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

        let derived = self.derivate()

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

    /// Returns the result of rotating the points of this Bézier curve by
    /// `angleInRadians` around the origin.
    public func rotated(by angleInRadians: Output.Scalar) -> Self {
        .init(
            p0: p0.rotated(by: angleInRadians),
            p1: p1.rotated(by: angleInRadians),
            p2: p2.rotated(by: angleInRadians)
        )
    }

    public func aligned(along line: LinearBezier2<Output>) -> Self {
        return .init(
            p0: p0.transposed(along: line),
            p1: p1.transposed(along: line),
            p2: p2.transposed(along: line)
        )
    }
}

extension QuadBezier2 where Output: ConstructibleBezier2PointType {
    /// Returns the extremas for the x and y axis of this cubic Bézier curve, as
    /// two Bézier curves that represent the axis on the Y axis, and 't' as the
    /// X axis, ranging from 0 to 1.
    public func extremas() -> (x: Self, y: Self) {
        func xAt(_ index: Int) -> Output.Scalar {
            Output.Scalar(index) / Output.Scalar(2)
        }

        let xBezier = Self(
            p0: .init(x: xAt(0), y: p0.x),
            p1: .init(x: xAt(1), y: p1.x),
            p2: .init(x: xAt(2), y: p2.x)
        )
        let yBezier = Self(
            p0: .init(x: xAt(0), y: p0.y),
            p1: .init(x: xAt(1), y: p1.y),
            p2: .init(x: xAt(2), y: p2.y)
        )

        return (xBezier, yBezier)
    }

    /// Returns the roots of this quadratic Bézier.
    ///
    /// If one or more of the roots fall outside the range of 0-1, or are not
    /// computable, `nil` is returned in their place, instead.
    public func roots() -> (x: Input?, y: Input?) {
        typealias Scalar = Output.Scalar

        func inRange(_ t: Input) -> Bool {
            t >= 0 && t <= 1
        }

        let derived = self.derivate()

        let a = derived[0]
        let b = derived[1]

        let dividend = b - a

        var x: Input?
        var y: Input?

        if dividend.x != 0 {
            let t = -a.x / dividend.x

            if inRange(t) {
                x = t
            }
        }
        if dividend.y != 0 {
            let t = -a.y / dividend.y

            if inRange(t) {
                y = t
            }
        }

        return (x, y)
    }
}
