/// A wrapper object that caches information related to its underlying Bézier
/// curve and queries made to it.
public class CachedBezier<Bezier: BezierType> {
    var cache: Cache = Cache()

    @usableFromInline
    var bezier: Bezier

    public init(bezier: Bezier) {
        self.bezier = bezier
    }

    /// Flushes all cached values, reducing memory usage but requiring recomputation
    /// on next invocations of cacheable accessors.
    public func flushCachedValues() {
        cache.flushCachedValues()
    }

    @usableFromInline
    struct Cache {
        @usableFromInline
        typealias CacheKey = Int

        @usableFromInline
        var series: [Int: [Output]] = [:]
        
        @usableFromInline
        var lookupTables: [Int: BezierLookUpTable<Bezier>] = [:]
        
        @usableFromInline
        var other: [CacheKey: Any] = [:]

        mutating func flushCachedValues() {
            series.removeAll()
            lookupTables.removeAll()
            other.removeAll()
        }

        @inlinable
        mutating func cacheOrCompute<T>(key: CacheKey, _ compute: () -> T) -> T {
            return _cacheOrCompute(
                other[key] as? T,
                { other[key] = $0 },
                compute
            )
        }

        @inlinable
        mutating func cacheOrComputeSeries(
            steps: Int,
            _ compute: () -> [Output]
        ) -> [Output] {

            return _cacheOrComputeDictionary(
                key: steps,
                &series,
                compute
            )
        }

        @inlinable
        mutating func cacheOrComputeLookupTable(
            steps: Int,
            _ compute: () -> BezierLookUpTable<Bezier>
        ) -> BezierLookUpTable<Bezier> {

            return _cacheOrComputeDictionary(
                key: steps,
                &lookupTables,
                compute
            )
        }

        // MARK: -

        /// Convenience for manipulating items in a cache that is stored as a
        /// dictionary of key/values for the cached content.
        @inlinable
        func _cacheOrComputeDictionary<Key: Hashable, T>(
            key: Key,
            _ storage: inout [Key: T],
            _ cacheComputer: () -> T
        ) -> T {

            return _cacheOrCompute(
                storage[key],
                { storage[key] = $0 },
                cacheComputer
            )
        }

        /// Convenience for manipulating items in a cache by abstracting on top
        /// of the caching and value computation interface.
        @inlinable
        func _cacheOrCompute<T>(
            _ cacheGetter: @autoclosure () -> T?,
            _ cacheSetter: (T) -> Void,
            _ cacheComputer: () -> T
        ) -> T {
            
            if let cached = cacheGetter() {
                return cached
            }

            let value = cacheComputer()
            cacheSetter(value)

            return value
        }
    }
}

extension CachedBezier: BezierType {
    public typealias Input = Bezier.Input
    public typealias Output = Bezier.Output

    public var startInput: Bezier.Input {
        bezier.startInput
    }

    public var endInput: Bezier.Input {
        bezier.endInput
    }

    public var pointCount: Int {
        bezier.pointCount
    }

    public subscript(pointIndex: Int) -> Bezier.Output {
        bezier[pointIndex]
    }

    public func compute(at input: Input) -> Output {
        bezier.compute(at: input)
    }

    public func computeSeries(steps: Int) -> [Bezier.Output] {
        cache.cacheOrComputeSeries(steps: steps) {
            bezier.computeSeries(steps: steps)
        }
    }

    /// - note: The result of this operation is cached and reused on next invocations
    /// with the same input `steps`.
    public func createLookupTable(steps: Int) -> BezierLookUpTable<Bezier> {
        cache.cacheOrComputeLookupTable(steps: steps) {
            bezier.createLookupTable(steps: steps)
        }
    }

    @inlinable
    public func projectApproximate(
        to point: Output,
        steps: Int,
        maxIterations: Int,
        tolerance: Output.Scalar
    ) -> (t: Input, output: Output) {
        
        return bezier.projectApproximate(
            to: point,
            steps: steps,
            maxIterations: maxIterations,
            tolerance: tolerance
        )
    }
}

extension CachedBezier: Bounded2BezierType where Bezier: Bounded2BezierType {
    static var _boundingRegionCacheKey: Cache.CacheKey {
        @inlinable
        get { 0b0000_0001 }
    }

    /// - note: The result of this operation is cached.
    public func boundingRegion() -> (minimum: Bezier.Output, maximum: Bezier.Output) {
        cache.cacheOrCompute(key: Self._boundingRegionCacheKey) {
            bezier.boundingRegion()
        }
    }
}
