import SwiftUI

@MainActor
extension Binding where Value == ClosedRange<Date>? {
    var timeRange: Binding<TimeRange?> {
        Binding<TimeRange?>(
            get: { wrappedValue.map { TimeRange(start: $0.lowerBound, end: $0.upperBound) } },
            set: { range in
                if let range, range.start <= range.end {
                    wrappedValue = range.start...range.end
                } else { wrappedValue = nil }
            }
        )
    }
}

extension CalendarView where Day == DefaultDayView, Header == DefaultCalendarHeaderView, Weekday == DefaultWeekdaysHeaderView {
    /// Source-compatible initialization using an inclusive native date range.
    public init(date: Binding<Date>, selection: Binding<ClosedRange<Date>?>,
                calendar: Calendar = Calendar(identifier: .gregorian), type: CalendarType = .monthly,
                colorSet: any CalendarColorSet = DefaultCalendarColorSet(),
                contentColorIndicator: @escaping (Date) -> Color? = { _ in nil }) {
        self.init(date: date, selection: selection.timeRange, calendar: calendar, type: type,
                  colorSet: colorSet, contentColorIndicator: contentColorIndicator)
    }
}

extension CalendarContentView {
    public init(type: CalendarType = .monthly, selection: Binding<ClosedRange<Date>?>,
                previewDate: Date, calendar: Calendar,
                @ViewBuilder dayView: @escaping (Date, Calendar, Bool, DaySelection?) -> Day) {
        self.init(type: type, selection: selection.timeRange, previewDate: previewDate,
                  calendar: calendar, dayView: dayView)
    }
}
