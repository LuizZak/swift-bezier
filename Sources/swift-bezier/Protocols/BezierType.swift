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

        typealias State = (closest: (Input, Output), iterations: Int)

        let lookup = createLookupTable(steps: steps)

        guard let closestIndex = lookup.closestEntryIndex(toOutput: point) else {
            return (startInput, self[0])
        }

        let searchRangeIndex = (start: max(0, closestIndex - 1), end: min(lookup.count - 1, closestIndex + 1))

        if searchRangeIndex.start == searchRangeIndex.end {
            return lookup[searchRangeIndex.start] as (Input, Output)
        }

        let searchRange = (start: lookup[searchRangeIndex.start], end: lookup[searchRangeIndex.end])
        let currentDistance = lookup[closestIndex].output.distanceSquared(to: point)

        let t = binarySearchInput(
            min: searchRange.start.input,
            max: searchRange.end.input,
            current: (lookup[closestIndex].input, currentDistance),
            maxIterations: maxIterations
        ) { (input, currentDistance) in

            let error = currentDistance - compute(at: input).distanceSquared(to: point)

            if error < tolerance {
                return currentDistance
            } else {
                return error
            }
        }

        return (t, compute(at: t))
    }
}
