extension CachedBezier {
    /// Convenience initializer for creating `CachedBezier` instances for
    /// `LinearBezier` types.
    public convenience init<Point: Bezier2PointType>(
        p0: Point,
        p1: Point
    ) where Bezier == LinearBezier<Point> {

        let bezier = Bezier(p0: p0, p1: p1)

        self.init(bezier: bezier)
    }
}
