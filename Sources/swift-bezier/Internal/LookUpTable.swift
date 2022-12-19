/// A lookup table for caching values that are spaced along a number line.
public struct LookUpTable<Input: Comparable & SignedNumeric, Output> {
    /// The type for the entries on this lookup table.
    public typealias Entry = (input: Input, output: Output)

    @usableFromInline
    var table: [Entry]

    /// Returns the number of entries on this lookup table.
    public var count: Int {
        table.count
    }

    /// Subscripts directly into an entry on this lookup table.
    ///
    /// - precondition: `index >= 0 && index < self.count`.
    public subscript(index: Int) -> Entry {
        table[index]
    }

    @inlinable
    init(table: [Entry]) {
        self.table = table.sorted(by: { $0.input < $1.input })
    }

    /// Looks up the closest entry to a given input value.
    @inlinable
    public func closestEntry(to input: Input) -> Entry? {
        guard let index = closestInputIndex(to: input) else {
            return nil
        }

        return table[index]
    }

    /// Looks up the closest output to a given input value.
    ///
    /// Returns `nil` if this lookup table is empty.
    @inlinable
    public func closestOutput(to input: Input) -> Output? {
        guard let index = closestInputIndex(to: input) else {
            return nil
        }

        return table[index].output
    }

    /// Looks up the index on `table` for the closest input value to `input`.
    ///
    /// Returns `nil` if this lookup table is empty.
    @inlinable
    public func closestInputIndex(to input: Input) -> Int? {
        guard !table.isEmpty else {
            return nil
        }
        guard table.count > 1, let first = table.first, let last = table.last else {
            return 0
        }
        if input <= first.input {
            return 0
        }
        if input >= last.input {
            return table.count - 1
        }

        guard let index = table.lastIndex(where: { $0.input < input }), index < table.count - 1 else {
            return table.count - 1
        }

        // Check if we are closer to index or index + 1
        let di = (table[index].input - input).magnitude
        let dNext = (table[index + 1].input - input).magnitude

        if di < dNext {
            return index
        } else {
            return index + 1
        }
    }
}
