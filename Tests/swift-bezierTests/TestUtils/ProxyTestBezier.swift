import SwiftBezier

/// A proxy Bézier that passes invoked members to an underlying `BezierType`
/// while recording the calls to be later inspected.
class ProxyTestBezier<Bezier: BezierType>: BezierType {
    typealias Input = Bezier.Input
    typealias Output = Bezier.Output

    var bezier: Bezier

    var startInput: Input {
        bezier.startInput
    }

    var endInput: Input {
        bezier.endInput
    }

    var pointCount: Int {
        bezier.pointCount
    }

    subscript(pointIndex: Int) -> Output {
        bezier[pointIndex]
    }

    init(bezier: Bezier) {
        self.bezier = bezier
    }

    var computeAt_calls: [(Input)] = []
    func compute(at input: Input) -> Output {
        computeAt_calls.append(input)

        return bezier.compute(at: input)
    }

    var computeSeriesSteps_calls: [(Int)] = []
    func computeSeries(steps: Int) -> [Bezier.Output] {
        computeSeriesSteps_calls.append((steps))
        
        return bezier.computeSeries(steps: steps)
    }

    var createLookupTable_calls: [(Int)] = []
    func createLookupTable(steps: Int) -> BezierLookUpTable<Bezier> {
        createLookupTable_calls.append((steps))

        return bezier.createLookupTable(steps: steps)
    }
}

// For testing calls to a `Bounded2BezierType` type.
class BoundedProxyTestBezier<Bezier: Bounded2BezierType>: ProxyTestBezier<Bezier>, Bounded2BezierType {
    var boundingRegion_calls: [(Void)] = []
    func boundingRegion() -> (minimum: Bezier.Output, maximum: Bezier.Output) {
        boundingRegion_calls.append(())

        return bezier.boundingRegion()
    }
}
