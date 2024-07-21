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

    /// Looks up the indices on `table` that approximate the given producer function
    /// towards zero, and returns the indices of the inputs that maximally approached
    /// zero.
    ///
    /// Returns an empty array if this lookup table is empty.
    ///
    /// Expects `producer` to be a contiguous function mapping `Input` into
    /// `Output.Scalar`.
    @inlinable
    public func approximateToZero(
        _ producer: (Output) -> Output.Scalar
    ) -> [Int] {

        var cache: [Int: Output.Scalar] = [:]

        func computeDiff(index: Int) -> Output.Scalar {
            if let cached = cache[index] {
                return cached
            }

            let value = producer(table[index].output)

            cache[index] = value

            return value
        }

        var indices: [Int] = []

        for i in 0..<table.count {
            let current = computeDiff(index: i)
            let prev = i > 0 ? computeDiff(index: i - 1) : current
            let next = i < table.count - 1 ? computeDiff(index: i + 1) : current

            // Find local minima
            if i == 0 && current < next {
                indices.append(i)
            } else if i == table.count - 1 && current < prev {
                indices.append(i)
            } else if current <= next && current <= prev {
                indices.append(i)
            }
        }

        return indices
    }
}
