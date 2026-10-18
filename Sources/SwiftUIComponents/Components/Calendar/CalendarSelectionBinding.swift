import SwiftUI

@MainActor
extension Binding where Value == ClosedRange<Date>? {
    var timeRange: Binding<TimeRange?> {
        func write(_ range: TimeRange?, to binding: Binding<ClosedRange<Date>?>) {
            if let range, range.start <= range.end {
                binding.wrappedValue = range.start...range.end
            } else {
                binding.wrappedValue = nil
            }
        }
        let read: @MainActor () -> TimeRange? = {
            wrappedValue.map { TimeRange(start: $0.lowerBound, end: $0.upperBound) }
        }
        // Passing the actor-isolated getter directly crashes Swift 6.3 during IR generation.
        #if os(Android)
        return Binding<TimeRange?>(get: { read() }, set: { range in write(range, to: self) })
        #else
        return Binding<TimeRange?>(get: { read() }, set: { range, transaction in
            // Forward explicitly to the source binding as well as its observable owner.
            withTransaction(transaction) { write(range, to: self.transaction(transaction)) }
        })
        #endif
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
