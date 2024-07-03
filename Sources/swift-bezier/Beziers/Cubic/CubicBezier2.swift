/// A 2-dimensional cubic Bézier curve type.
public typealias CubicBezier2<Point: Bezier2PointType> = CubicBezier<Point>

extension CubicBezier2: Bezier2Type, BoundedBezier2Type {
    /// Returns the minimal bounding region for this cubic Bézier curve.
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

    /// Returns the result of rotating the points of this Bézier curve by
    /// `angleInRadians` around the origin.
    public func rotated(by angleInRadians: Output.Scalar) -> Self {
        .init(
            p0: p0.rotated(by: angleInRadians),
            p1: p1.rotated(by: angleInRadians),
            p2: p2.rotated(by: angleInRadians),
            p3: p3.rotated(by: angleInRadians)
        )
    }

    public func aligned(along line: LinearBezier2<Output>) -> Self {
        return .init(
            p0: p0.transposed(along: line),
            p1: p1.transposed(along: line),
            p2: p2.transposed(along: line),
            p3: p3.transposed(along: line)
        )
    }

    public func approximateIntersection(
        with other: Self,
        threshold: Output.Scalar
    ) -> [(Input, Input)] {
        let result = recurseIntersection(
            (startInput, endInput),
            with: other,
            (other.startInput, other.endInput),
            threshold: threshold
        )

        return result
    }

    /// Gets a normal vector for this Bézier curve at a given point.
    public func normal(at input: Output.Scalar) -> Output {
        let derivative = self.derivate()

        return derivative.compute(at: input).rightRotated()
    }
}

extension CubicBezier2 {
    @inlinable
    func recurseIntersection(
        _ selfRange: (Input, Input),
        with other: Self,
        _ otherRange: (Input, Input),
        threshold: Output.Scalar
    ) -> [(Input, Input)] {
        func isAboveThreshold(
            _ box: (minimum: Output, maximum: Output)
        ) -> Bool {
            let area = box.maximum - box.minimum

            return area.x > threshold || area.y > threshold
        }
        func left(of period: (Input, Input)) -> (Input, Input) {
            let range = period.1 - period.0
            return (period.0, period.0 + range / 2)
        }
        func right(of period: (Input, Input)) -> (Input, Input) {
            let range = period.1 - period.0
            return (period.0 + range / 2, period.1)
        }
        func intersect(
            _ box1: (minimum: Output, maximum: Output),
            _ box2: (minimum: Output, maximum: Output)
        ) -> Bool {
            box1.minimum <= box2.maximum && box1.maximum >= box2.minimum
        }
        func recurse(
            _ lhs: Self, _ selfRange: (Input, Input),
            _ rhs: Self, _ otherRange: (Input, Input),
            result: inout [(Input, Input)]
        ) {
            let inputs = lhs.recurseIntersection(
                selfRange,
                with: rhs,
                otherRange,
                threshold: threshold
            )

            result.append(contentsOf: inputs)
        }

        let selfBox = self.boundingRegion()
        let otherBox = other.boundingRegion()

        if !intersect(selfBox, otherBox) {
            return []
        }
        if !isAboveThreshold(selfBox) || !isAboveThreshold(otherBox) {
            return [(selfRange.0, otherRange.0)]
        }

        // Split and recurse
        let (selfLeft, selfRight) = self.split(at: 0.5)
        let (otherLeft, otherRight) = other.split(at: 0.5)

        var result: [(Input, Input)] = []

        recurse(selfLeft, left(of: selfRange), otherLeft, left(of: otherRange), result: &result)
        recurse(selfLeft, left(of: selfRange), otherRight, right(of: otherRange), result: &result)
        recurse(selfRight, right(of: selfRange), otherLeft, left(of: otherRange), result: &result)
        recurse(selfRight, right(of: selfRange), otherRight, right(of: otherRange), result: &result)

        return result
    }
}

extension CubicBezier2 where Output: ConstructibleBezier2PointType {
    /// Returns the extremas for the x and y axis of this cubic Bézier curve, as
    /// two Bézier curves that represent the axis on the Y axis, and 't' as the
    /// X axis, ranging from 0 to 1.
    public func extremas() -> (x: Self, y: Self) {
        func xAt(_ index: Int) -> Output.Scalar {
            Output.Scalar(index) / Output.Scalar(3)
        }

        let xBezier = Self(
            p0: .init(x: xAt(0), y: p0.x),
            p1: .init(x: xAt(1), y: p1.x),
            p2: .init(x: xAt(2), y: p2.x),
            p3: .init(x: xAt(3), y: p3.x)
        )
        let yBezier = Self(
            p0: .init(x: xAt(0), y: p0.y),
            p1: .init(x: xAt(1), y: p1.y),
            p2: .init(x: xAt(2), y: p2.y),
            p3: .init(x: xAt(3), y: p3.y)
        )

        return (xBezier, yBezier)
    }

    /// Returns the roots of this cubic Bézier.
    ///
    /// If one or more of the roots fall outside the range of 0-1, or are not
    /// computable, `nil` is returned in their place, instead.
    ///
    /// In case only one root is valid for each coordinate, the `(x/y)0` scalar
    /// will be non-nil, while `(x/y)1` will be `nil`.
    public func roots() -> (x0: Input?, x1: Input?, y0: Input?, y1: Input?) {
        typealias Scalar = Output.Scalar

        // a = -3P₀ + 9P₁ - 9P₂ + 3P₃
        let a: Output = coefficients.a * 3
        // b = 6P₀ - 12P₁ + 6P₂
        let b: Output = coefficients.b * 2
        // c = -3P₀ + 3P₁
        let c: Output = coefficients.c

        func inRange(_ t: Input) -> Bool {
            t >= 0 && t <= 1
        }

        var x0: Input?
        var x1: Input?
        var y0: Input?
        var y1: Input?

        if a.x != 0 {
            // Quadratic
            let (t0x, t1x) = QuadraticSolver.solve(a: a.x, b: b.x, c: c.x) ?? (-1, -1)

            if inRange(t0x) {
                x0 = t0x
            }
            if inRange(t1x) {
                x1 = t1x
            }
        } else if b.x != 0 {
            // Linear
            let tx = -c.x / b.x

            if inRange(tx) {
                x0 = tx
            }
        } else {
            // Constant?
            if inRange(-c.x) {
                x0 = -c.x
            }
        }

        if a.y != 0 {
            // Quadratic
            let (t0y, t1y) = QuadraticSolver.solve(a: a.y, b: b.y, c: c.y) ?? (-1, -1)

            if inRange(t0y) {
                y0 = t0y
            }
            if inRange(t1y) {
                y1 = t1y
            }
        } else if b.y != 0 {
            // Linear
            let ty = -c.y / b.y

            if inRange(ty) {
                y0 = ty
            }
        } else {
            // Constant?
            if inRange(-c.y) {
                x0 = -c.y
            }
        }

        return (x0, x1, y0, y1)
    }
}
