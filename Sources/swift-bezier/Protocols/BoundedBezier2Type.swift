/// A 2-dimensional Bézier curve type that can be bounded into space using a tight
/// axis-aligned bounding box, i.e. the smallest bounding box capable of fitting
/// all points of this Bézier.
public protocol BoundedBezier2Type: Bezier2Type {
    /// Returns the minimum axis-aligned bounding region for this Bézier curve
    /// as a pair of minimum and maximum outputs that this Bézier curve can
    /// produce within its `startInput` and `endInput`.
    func boundingRegion() -> (minimum: Output, maximum: Output)
}
