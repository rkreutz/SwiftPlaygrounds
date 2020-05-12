import UIKit

extension Calendar.Component: CaseIterable {

    public typealias AllCases = [Calendar.Component]

    public static var allCases: Calendar.Component.AllCases = [
        .calendar,
        .day,
        .era,
        .hour,
        .minute,
        .month,
        .nanosecond,
        .quarter,
        .second,
        .timeZone,
        .weekday,
        .weekdayOrdinal,
        .weekOfMonth,
        .weekOfYear,
        .year,
        .yearForWeekOfYear
    ]
}

@propertyWrapper
public struct DateComponentsFilter {

    var allowedComponents: Set<Calendar.Component>
    var internalValue: DateComponents = DateComponents()

    public init(allowedComponents: Set<Calendar.Component>) {

        self.allowedComponents = allowedComponents
    }

    public var wrappedValue: DateComponents {

        get { internalValue }
        set {

            var newComponents = newValue
            Calendar.Component.allCases.forEach {

                guard !allowedComponents.contains($0) else { return }
                switch $0 {

                case .calendar:
                    newComponents.calendar = nil

                case .timeZone:
                    newComponents.timeZone = nil

                default:
                    newComponents.setValue(nil, for: $0)
                }
            }
            internalValue = newComponents
        }
    }
}

class Something {

    @DateComponentsFilter(allowedComponents: [.year, .month, .day]) var components: DateComponents
}

let something = Something()
something.components = Calendar.current.dateComponents(Set(Calendar.Component.allCases), from: Date())
print(something.components)
something.components.date

let date1: Date? = Date()
let date2: Date? = Date().addingTimeInterval(100)

extension Optional where Wrapped == Date {

    static func ... (lhs: Self, rhs: Self) -> ClosedRange<Date> {

        switch (lhs, rhs) {

        case let (.some(lhs), .some(rhs)):
            return lhs ... rhs

        case let (.none, .some(rhs)):
            return Date.distantPast ... rhs

        case let (.some(lhs), .none):
            return lhs ... Date.distantFuture

        case (.none, .none):
            return Date.distantPast ... Date.distantFuture
        }
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


Date().addingTimeInterval(10000).clamping(to: date1 ... date2)
