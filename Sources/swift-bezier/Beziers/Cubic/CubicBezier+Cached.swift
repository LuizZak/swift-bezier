extension CachedBezier {
    /// Convenience initializer for creating `CachedBezier` instances for
    /// `CubicBezier` types.
    public convenience init<Point: Bezier2PointType>(
        p0: Point,
        p1: Point,
        p2: Point,
        p3: Point
    ) where Bezier == CubicBezier<Point> {

        let bezier = Bezier(p0: p0, p1: p1, p2: p2, p3: p3)

        self.init(bezier: bezier)
    }
}
