import Foundation

/// An inclusive interval. Reversed endpoints describe an empty range.
public struct TimeRange: Hashable, Codable, Sendable {
    public var start: Date
    public var end: Date

    public init() {
        let now = Calendar.current.startOfDay(for: Date())
        self.start = now
        self.end = now
    }

    public init(start: Date, end: Date) {
        self.start = start
        self.end = end
    }

    public func contains(_ date: Date) -> Bool { start <= date && date <= end }

    /// The requested calendar component's span, prioritizing days when requested.
    public func span(calendar: Calendar, units: Set<Calendar.Component> = [.day]) -> Int {
        let components = calendar.dateComponents(units, from: calendar.startOfDay(for: start),
                                                  to: calendar.startOfDay(for: end))
        for unit in [Calendar.Component.day, .year, .month, .weekOfYear, .weekOfMonth, .hour, .minute, .second] where units.contains(unit) {
            if let value = components.value(for: unit) { return value }
        }
        return 0
    }

    /// Every calendar day intersecting the interval, including both endpoints.
    public func toArray(calendar: Calendar) -> [Date] {
        guard start <= end else { return [] }
        let last = calendar.startOfDay(for: end)
        var day = calendar.startOfDay(for: start)
        var result: [Date] = []
        while day <= last {
            result.append(day)
            guard let next = calendar.date(byAdding: .day, value: 1, to: day), next > day else { break }
            day = next
        }
        return result
    }
}

// Existing clients can keep native ClosedRange values while sharing the same rules.
public extension ClosedRange where Bound == Date {
    func span(calendar: Calendar, units: Set<Calendar.Component>) -> Int {
        TimeRange(start: lowerBound, end: upperBound).span(calendar: calendar, units: units)
    }

    func toArray(calendar: Calendar) -> [Date] {
        TimeRange(start: lowerBound, end: upperBound).toArray(calendar: calendar)
    }
}
