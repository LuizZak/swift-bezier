extension CachedBezier {
    /// Convenience initializer for creating `CachedBezier` instances for
    /// `QuadBezier` types.
    public convenience init<Point: Bezier2PointType>(
        p0: Point,
        p1: Point,
        p2: Point
    ) where Bezier == QuadBezier<Point> {

        let bezier = Bezier(p0: p0, p1: p1, p2: p2)

        self.init(bezier: bezier)
    }
}
