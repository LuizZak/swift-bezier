/// Protocol for Bézier curve types, with outputs that are geometric in nature.
public protocol BezierType {
    /// The type for the input of this Bézier curve type.
    associatedtype Input: Comparable

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
}

extension BezierType where Input: FloatingPoint {
    @inlinable
    public var startInput: Input { 0 }
    
    @inlinable
    public var endInput: Input { 1 }
}
