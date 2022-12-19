/// A lookup table that caches information about points derived from a Bézier
/// curve.
public typealias BezierLookUpTable<Bezier: BezierType> = LookUpTable<Bezier.Input, Bezier.Output>

extension BezierLookUpTable where Output: BezierPointType {
    /// Looks up the closest output to a given output value.
    ///
    /// Returns `nil` if this lookup table is empty.
    @inlinable
    public func closestEntry(toOutput output: Output) -> Entry? {
        guard let index = closestEntryIndex(toOutput: output) else {
            return nil
        }

        return table[index]
    }

    /// Looks up the closest entry index to a given output value.
    ///
    /// Returns `nil` if this lookup table is empty.
    @inlinable
    public func closestEntryIndex(toOutput output: Output) -> Int? {
        var closest: (Int, Output.Scalar)?

        for (i, entry) in table.enumerated() {
            let dist = output.distanceSquared(to: entry.output)

            if let c = closest {
                if dist < c.1 {
                    closest = (i, dist)
                }
            } else {
                closest = (i, dist)
            }
        }

        return closest?.0
    }
}
