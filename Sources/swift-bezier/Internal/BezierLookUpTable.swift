/// A lookup table that caches information about points derived from a Bézier
/// curve.
public typealias BezierLookUpTable<Bezier: BezierType> = LookUpTable<Bezier.Input, Bezier.Output>
