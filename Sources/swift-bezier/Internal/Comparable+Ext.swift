extension Comparable {
    @inlinable
    func clamp(min minimum: Self, max maximum: Self) -> Self {
        min(max(self, minimum), maximum)
    }
}
