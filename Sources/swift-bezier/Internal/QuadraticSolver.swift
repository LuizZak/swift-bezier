/// Simple quadratic equation solver.
@usableFromInline
enum QuadraticSolver {
    /// Solves a quadratic equation with a given set of coefficients.
    /// Returns `nil` if discriminant (`Δ = √b² - 4ac`) is negative, or `a` is
    /// zero.
    @inlinable
    static func solveDouble(a: Double, b: Double, c: Double) -> (x0: Double, x1: Double)? {
        return solve(a: a, b: b, c: c)
    }
    
    /// Solves a quadratic equation with a given set of coefficients.
    /// Returns `nil` if discriminant (`Δ = √b² - 4ac`) is negative, or `a` is
    /// zero.
    @inlinable
    static func solve<T: FloatingPoint>(a: T, b: T, c: T) -> (x0: T, x1: T)? {
        guard a != .zero else {
            return nil
        }

        let discriminant = (b * b).addingProduct(-4, a * c)
        guard discriminant >= .zero else {
            return nil
        }
        let delta = discriminant.squareRoot()

        let a2 = a * 2

        let t0 = (-b + delta) / a2
        let t1 = (-b - delta) / a2

        return (t0, t1)
    }
}
