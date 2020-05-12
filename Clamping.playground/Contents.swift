import Foundation

public extension Numeric where Self: Comparable {

    func clamping(to bounds: ClosedRange<Self>) -> Self {

        return max(min(self, bounds.upperBound), bounds.lowerBound)
    }

    func clamping(to bounds: PartialRangeFrom<Self>) -> Self {

        return max(self, bounds.lowerBound)
    }

    func clamping(to bounds: PartialRangeThrough<Self>) -> Self {

        return min(self, bounds.upperBound)
    }
}

public extension Comparable {

    /// Clamps the value to a given range in case it is out of the specified range
    /// - Parameter range: the range to which the value should be clamped
    func clamping(to range: ClosedRange<Self>) -> Self {

        if range.lowerBound > self {

            return range.lowerBound
        } else if range.upperBound < self {

            return range.upperBound
        } else {

            return self
        }
    }
}

public extension Strideable where Self.Stride: SignedInteger {

    /// Clamps a value to a min and a max value in a CountableRange<Int>, e.g. 10 in a range of 0 to 5 (0..<6) would be clamped to 5
    ///
    /// - Examples:
    ///     - 10.clamping(0..<6) == 5
    ///     - (-3).clamping(0..<6) == 0
    ///     - 3.clamping(0..<6) == 3
    /// - Parameter bounds: the countable range representing the values which the integer should be clamped, e.g. 0..<6 where 0 would be the lower bound (min value) and 6 would be the non inclusive upper bound, so the actual upper bound would be 6 - 1 = 5 which would be the max value
    /// - Returns: the value clamped to the range specified
    func clamping(to bounds: CountableRange<Self>) -> Self {

        return Swift.max(Swift.min(self, bounds.last ?? self), bounds.first ?? self)
    }
}

1.clamping(to: 0..<6)
(-1).clamping(to: 0..<6)
6.clamping(to: 0..<6)
7.clamping(to: 0..<6)
7.clamping(to: 0...)
(-7).clamping(to: 0...)
7.clamping(to: ...10)
10.clamping(to: ...10)
11.clamping(to: ...10)
11.0.clamping(to: ...10.0)

