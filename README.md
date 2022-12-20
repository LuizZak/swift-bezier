# SwiftBezier

An implementation of [Bézier curves] in Swift.

[Bézier curves]: https://en.wikipedia.org/wiki/Bézier_curve

```swift
import SwiftBezier

let curve = CubicBezier2D(
    p0: .init(x: 5.0, y: 6.0),
    p1: .init(x: 15.0, y: 6.0),
    p2: .init(x: 5.0, y: 16.0),
    p3: .init(x: 15.0, y: 16.0)
)

print(curve.compute(at: 0.37))
// Bezier2DPoint(x: 9.912120000000002, y: 9.09394)

print(curve.boundingRegion()) // Available for 2-dimensional cubic Bézier curves
// (minimum: Bezier2DPoint(x: 5.0, y: 6.0), maximum: Bezier2DPoint(x: 15.0, y: 16.0))
```
