/// Protocol for Bézier curve types, with outputs that are geometric in nature.
public protocol BezierType {
    /// The type for the input of this Bézier curve type.
    associatedtype Input: FloatingPoint

    /// The type for the output of this Bézier curve type.
    associatedtype Output: BezierPointType

    /// The minimal input that can be computed in this Bézier curve.
    var startInput: Input { get }

    /// The maximal input that can be computed in this Bézier curve.
    var endInput: Input { get }

    /// The number of points on this Bézier curve. Should always be `>= 1` for
    /// any degree of Bézier curve object greater than -1.
    var pointCount: Int { get }

    /// Returns the point at a specified point index.
    /// - precondition: `pointIndex >= 0 && pointIndex < pointCount`.
    subscript(pointIndex: Int) -> Output { get }

    /// Gets a list of all control points for this Bézier curve.
    /// Always contains at least one point for any degree of Bézier curve object
    /// greater than -1.
    var points: [Output] { get }

    /// Gets the first control point of this Bézier curve object. It is
    /// necessarily the same as the point obtained by `compute(at: startInput)`.
    var firstPoint: Output { get }

    /// Gets the last control point of this Bézier curve object. It is
    /// necessarily the same as the point obtained by `compute(at: endInput)`.
    var lastPoint: Output { get }

    /// Requests that a new output value be computed at a specified input using
    /// the fastest implementation mode available for this type.
    func compute(at input: Input) -> Output

    /// Requests that a series of output values be computed for this Bézier,
    /// with intervals that divide `startInput` and `endInput` into `steps` number
    /// of equally-spaced input values.
    ///
    /// Returned array always contains the result of `startInput` and `endInput`
    /// themselves, which are the first and last points on this Bézier curve, so
    /// those two points don't count towards the number of steps.
    ///
    /// - precondition: `steps >= 0`.
    func computeSeries(steps: Int) -> [Output]

    /// Creates a lookup table for this Bézier curve with a given number of
    /// subdivision steps within it.
    ///
    /// Returned lookup table always contains the result of `startInput` and
    /// `endInput` themselves, which are the first and last points on this Bézier
    /// curve, so those two points don't count towards the number of steps.
    ///
    /// - precondition: `steps >= 0`.
    func createLookupTable(steps: Int) -> BezierLookUpTable<Self>

    /// Performs an approximation of the closest point on this Bézier to a given
    /// point outside of it.
    ///
    /// The approximation is controlled by a number of steps to split the Bézier
    /// into before the closest interval is found and iterating over it until
    /// it either exceeds a number of maximum iterations or the point approaches
    /// a limit where changes to input are smaller than `tolerance`.
    func projectApproximate(
        to point: Output,
        steps: Int,
        maxIterations: Int,
        tolerance: Output.Scalar
    ) -> (t: Input, output: Output)

    /// Performs an approximation of a given function on this Bézier towards zero.
    ///
    /// The approximation is controlled by a number of steps to split the Bézier
    /// into before the closest interval to zero is found and iterating over it
    /// until it either exceeds a number of maximum iterations or the function
    /// approaches a limit where changes to input are smaller than `tolerance`.
    ///
    /// Expects `producer` to be a contiguous function mapping `Input` into
    /// `Output.Scalar`.
    ///
    /// May produce multiple approximations depending on the degree of this Bézier
    /// curve.
    func approximate(
        _ producer: (Output) -> Output.Scalar,
        steps: Int,
        maxIterations: Int,
        tolerance: Output.Scalar
    ) -> [(t: Input, output: Output)]

    /// Returns the result of translating the points of this Bézier curve by
    /// `offset`.
    func translated(by offset: Output) -> Self
}

extension BezierType {
    @inlinable
    public var startInput: Input { 0 }

    @inlinable
    public var endInput: Input { 1 }

    @inlinable
    public var points: [Output] {
        return (0..<pointCount).map { self[$0] }
    }

    @inlinable
    public var firstPoint: Output {
        self[0]
    }

    @inlinable
    public var lastPoint: Output {
        self[pointCount - 1]
    }

    @inlinable
    public func computeSeries(steps: Int) -> [Output] {
        createLookupTable(steps: steps).table.map { $0.output }
    }

    @inlinable
    public func createLookupTable(steps: Int) -> BezierLookUpTable<Self> {
        precondition(steps >= 0)

        var values: [(input: Input, output: Output)] = []

        values.append((startInput, self[0]))

        if steps > 0 {
            let interval = (endInput - startInput) / Input(steps + 1)
            for step in 0..<steps {
                let value = Input(step + 1) * interval
                values.append(
                    (input: value, output: compute(at: value))
                )
            }
        }

        values.append((endInput, self[pointCount - 1]))

        return .init(table: values)
    }

    @inlinable
    public func projectApproximate(
        to point: Output,
        steps: Int,
        maxIterations: Int,
        tolerance: Output.Scalar
    ) -> (t: Input, output: Output) {

        let results =
            self.approximate({ $0.distanceSquared(to: point) },
                steps: steps,
                maxIterations: maxIterations,
                tolerance: tolerance
            )

        if let min = results.min(by: { $0.output.distanceSquared(to: point) < $1.output.distanceSquared(to: point) }) {
            return min
        }

        return (startInput, self[0])
    }

    @inlinable
    public func approximate(
        _ producer: (Output) -> Output.Scalar,
        steps: Int,
        maxIterations: Int,
        tolerance: Output.Scalar
    ) -> [(t: Input, output: Output)] {

        typealias State = (closest: (Input, Output), iterations: Int)

        let lookup = createLookupTable(steps: steps)

        let closestIndices = lookup.approximateToZero(producer)

        var results: [(t: Input, output: Output)] = []

        for closestIndex in closestIndices {
            let searchRangeIndex = (start: max(0, closestIndex - 1), end: min(lookup.count - 1, closestIndex + 1))

            if searchRangeIndex.start == searchRangeIndex.end {
                let t = lookup[searchRangeIndex.start].input
                let point = compute(at: t)
                if producer(compute(at: t)) < tolerance {
                    results.append((t, point))
                }
                continue
            }

            let searchRange = (start: lookup[searchRangeIndex.start], end: lookup[searchRangeIndex.end])
            let current = producer(lookup[closestIndex].output)

            let t = binarySearchInput(
                min: searchRange.start.input,
                max: searchRange.end.input,
                current: (lookup[closestIndex].input, current),
                maxIterations: maxIterations
            ) { (input, current) in

                //producer(lookup[closestIndex].output)
                let error = current - producer(lookup[closestIndex].output)

                if error < tolerance {
                    return current
                } else {
                    return error
                }
            }

            let point = compute(at: t)
            results.append((t, point))
        }

        return results
    }
}
