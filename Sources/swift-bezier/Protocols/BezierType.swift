/// Protocol for Bézier curve types, with outputs that are geometric in nature.
public protocol BezierType {
    /// The type for the input of this Bézier curve type.
    associatedtype Input: Comparable, SignedNumeric

    /// The type for the output of this Bézier curve type.
    associatedtype Output: BezierPointType

    /// The minimal input that can be computed in this Bézier curve.
    var startInput: Input { get }

    /// The maximal input that can be computed in this Bézier curve.
    var endInput: Input { get }

    /// The number of points on this Bézier curve.
    var pointCount: Int { get }

    /// Returns the point at a specified point index.
    /// - precondition: `pointIndex >= 0 && pointIndex < pointCount`.
    subscript(pointIndex: Int) -> Output { get }

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
}

extension BezierType {
    @inlinable
    public func computeSeries(steps: Int) -> [Output] {
        createLookupTable(steps: steps).table.map { $0.output }
    }
}

extension BezierType where Input: FloatingPoint {
    @inlinable
    public var startInput: Input { 0 }
    
    @inlinable
    public var endInput: Input { 1 }

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
}
