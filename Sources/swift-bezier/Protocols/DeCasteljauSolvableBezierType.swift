/// Protocol for Bézier curve types that can be solved using [De Casteljau's algorithm].
///
/// [De Casteljau's algorithm]: https://en.wikipedia.org/wiki/De_Casteljau%27s_algorithm
public protocol DeCasteljauSolvableBezierType: BezierType {
    /// Solves this Bézier curve using [De Casteljau's algorithm].
    ///
    /// Is slower than solving curves in polynomial form but is numerically
    /// stable.
    ///
    /// [De Casteljau's algorithm]: https://en.wikipedia.org/wiki/De_Casteljau%27s_algorithm
    func solveDeCasteljau(at input: Double) -> Output

    /// Splits this Bézier curve into two curves that overlap this curve,
    /// splitting it along a specified input interval that ranges from (0-1).
    func split(at input: Double) -> (left: Self, right: Self)
}

/// Solves a Bézier curve of arbitrary order using an implementation of
/// [De Casteljau's algorithm].
///
/// [De Casteljau's algorithm]: https://en.wikipedia.org/wiki/De_Casteljau%27s_algorithm
///
/// - precondition: `points.count > 1`.
@inlinable
public func solveDeCasteljau<Point: BezierPointType>(
    _ points: [Point],
    factor: Double
) -> Point {

    precondition(points.count > 1)

    var points = points

    let n = points.count
    for j in 1..<n {
        for k in 0..<(n - j) {
            points[k] = points[k].lerp(to: points[k + 1], factor: factor)
        }
    }

    return points[0]
}
