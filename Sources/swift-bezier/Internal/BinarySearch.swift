// TODO: Perhaps 'binary search' is no longer the appropriate term for this function, but for now we leave as is as it's not public API.

/// Performs a binary search by evaluating an error method, from `minimum` to
/// `maximum`, starting at `start`, approximating to a value of zero until the
/// closure `errorAt` returns `nil`, it returns `0`, indicating no further
/// iterations are required to approximate the error value, it returns the
/// same value as `current`, indicating a constant stretch was potentially found
/// and no pivot can be computed from there, or `maxIterations` is reached.
///
/// The end result is the last iterated `Input` sent to `errorAt` before the
/// iteration stopped.
@usableFromInline
func binarySearchInput<Input: FloatingPoint, ErrorValue: Comparable>(
    min minimum: Input,
    max maximum: Input,
    current: (Input, ErrorValue),
    maxIterations: Int,
    _ errorAt: (Input, _ current: ErrorValue) -> ErrorValue?
) -> Input {

    var current = current

    var range: (start: Input, end: Input) = (minimum, maximum)
    var pivot: Input {
        (range.start + range.end) / 2
    }

    var iterations = 0
    while iterations < maxIterations, let next = errorAt(pivot, current.1) {
        iterations += 1

        if next == current.1 {
            break
        }

        defer {
            current.0 = pivot
            current.1 = next
        }

        if next < current.1 {
            range.end = pivot
        } else if next > current.1 {
            range.start = pivot
        }
    }

    return current.0
}
