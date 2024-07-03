import SwiftBezier

/// A proxy Bézier that passes invoked members to an underlying `BezierType`
/// while recording the calls to be later inspected.
class ProxyTestBezier<Bezier: BezierType>: BezierType {
    typealias Input = Bezier.Input
    typealias Output = Bezier.Output
    typealias Scalar = Bezier.Output.Scalar

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

    var projectApproximate_calls: [(point: Bezier.Output, steps: Int, maxIterations: Int, tolerance: Output.Scalar)] = []
    func projectApproximate(
        to point: Bezier.Output,
        steps: Int,
        maxIterations: Int,
        tolerance: Output.Scalar
    ) -> (t: Bezier.Input, output: Bezier.Output) {

        projectApproximate_calls.append((
            point: point,
            steps: steps,
            maxIterations: maxIterations,
            tolerance: tolerance
        ))

        return bezier.projectApproximate(
            to: point,
            steps: steps,
            maxIterations: maxIterations,
            tolerance: tolerance
        )
    }

    var translated_calls: [Bezier.Output] = []
    func translated(by offset: Bezier.Output) -> Self {
        translated_calls.append(offset)

        bezier = bezier.translated(by: offset)
        return self
    }
}

// For testing calls to a `BoundedBezier2Type` type.
class BoundedProxyTestBezier<Bezier: BoundedBezier2Type>: ProxyTestBezier<Bezier>, BoundedBezier2Type {
    var boundingRegion_calls: [(Void)] = []
    func boundingRegion() -> (minimum: Output, maximum: Output) {
        boundingRegion_calls.append(())

        return bezier.boundingRegion()
    }

    var rotated_calls: [(Scalar)] = []
    func rotated(by angleInRadians: Scalar) -> Self {
        rotated_calls.append(angleInRadians)

        bezier = bezier.rotated(by: angleInRadians)
        return self
    }

    var aligned_calls: [(LinearBezier2<Output>)] = []
    public func aligned(along line: LinearBezier2<Output>) -> Self {
        aligned_calls.append(line)

        bezier = bezier.aligned(along: line)
        return self
    }
}
