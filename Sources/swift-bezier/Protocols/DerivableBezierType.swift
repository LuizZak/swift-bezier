/// Protocol for Bézier curve types that can be derived.
///
/// Derivatives of Bézier curves produce other Bézier curves of one degree less.
public protocol DerivableBezierType: BezierType {
    /// The type for derivatives of this Bézier curve type.
    associatedtype DerivativeBezier: BezierType where DerivativeBezier.Input == Input, DerivativeBezier.Output == Output

    /// Creates a derivative for this Bézier curve.
    func derivate() -> DerivativeBezier
}
