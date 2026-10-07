import Foundation

/// Calendar arithmetic shared by the views and selection rules. Uses calendar days,
/// rather than 24-hour intervals, so daylight-saving transitions remain correct.
struct CalendarGrid {
    let calendar: Calendar

    func periods(containing date: Date, type: CalendarType) -> [CalendarPeriod] {
        switch type {
        case .weekly:
            return [CalendarPeriod(month: date, dates: week(containing: date))]
        case .monthly:
            let month = calendar.dateInterval(of: .month, for: date)?.start ?? date
            return [CalendarPeriod(month: month, dates: self.month(containing: month))]
        case .yearly:
            return months(inYearContaining: date).map {
                CalendarPeriod(month: $0, dates: month(containing: $0))
            }
        }
    }

    func week(containing date: Date) -> [Date] {
        guard let start = calendar.dateInterval(of: .weekOfYear, for: date)?.start else { return [] }
        return days(startingAt: start, count: calendar.weekdaySymbols.count)
    }

    func month(containing date: Date) -> [Date] {
        guard let interval = calendar.dateInterval(of: .month, for: date),
              let dayRange = calendar.range(of: .day, in: .month, for: date) else { return [] }
        let weekdayCount = calendar.weekdaySymbols.count
        let leading = (calendar.component(.weekday, from: interval.start) - calendar.firstWeekday + weekdayCount) % weekdayCount
        guard let start = calendar.date(byAdding: .day, value: -leading, to: interval.start) else { return [] }
        let count = ((leading + dayRange.count + weekdayCount - 1) / weekdayCount) * weekdayCount
        return days(startingAt: start, count: count)
    }

    func months(inYearContaining date: Date) -> [Date] {
        guard let interval = calendar.dateInterval(of: .year, for: date) else { return [] }
        var result: [Date] = []
        var month = interval.start
        while month < interval.end {
            result.append(month)
            guard let next = calendar.date(byAdding: .month, value: 1, to: month), next > month else { break }
            month = next
        }
        return result
    }

    private func days(startingAt date: Date, count: Int) -> [Date] {
        (0..<count).compactMap { calendar.date(byAdding: .day, value: $0, to: date) }
    }
}

struct CalendarPeriod: Identifiable {
    let month: Date
    let dates: [Date]
    var id: Date { dates.first ?? month }
}

struct CalendarSelection {
    let calendar: Calendar

    func tapping(_ date: Date, selection: TimeRange?, multiple: Bool) -> TimeRange? {
        let date = calendar.startOfDay(for: date)
        guard let selection else { return TimeRange(start: date, end: date) }
        let start = calendar.startOfDay(for: selection.start)
        let end = calendar.startOfDay(for: selection.end)
        if !multiple {
            return date >= start && date <= end ? nil : TimeRange(start: date, end: date)
        }
        guard start == end, date != start else { return nil }
        return TimeRange(start: min(start, date), end: max(end, date))
    }

    func extending(to date: Date, selection: TimeRange?) -> TimeRange {
        let date = calendar.startOfDay(for: date)
        guard let selection else { return TimeRange(start: date, end: date) }
        return TimeRange(start: min(calendar.startOfDay(for: selection.start), date),
                         end: max(calendar.startOfDay(for: selection.end), date))
    }

    func normalized(_ selection: TimeRange?) -> TimeRange? {
        selection.map {
            TimeRange(start: calendar.startOfDay(for: $0.start), end: calendar.startOfDay(for: $0.end))
        }
    }

    /// Grid dates are already day boundaries; normalize the selection once for the entire grid.
    static func position(ofDay day: Date, in selection: TimeRange?) -> DaySelection? {
        guard let selection else { return nil }
        let start = selection.start
        let end = selection.end
        guard start <= day, day <= end else { return nil }
        if start == end { return .single }
        if day == start { return .leading }
        if day == end { return .trailing }
        return .inner
    }
}
