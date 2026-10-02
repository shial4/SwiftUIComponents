import SwiftUI

/// A calendar grid that supports individual selection, range selection and drag extension.
public struct CalendarContentView<Day: View>: View {
    @Binding private var selection: TimeRange?
    @State var width: Double = 0
    @State var rowFrames: [CalendarRowID: CGRect] = [:]
    private var isMultiselectionEnabled = true
    private var isSelectionEnabled = true
    private let type: CalendarType
    private let previewDate: Date
    private let calendar: Calendar
    private let dayView: (Date, Calendar, Bool, DaySelection?) -> Day
    private let monthSpacing: Double = 8
    private var yearColumns: Int {
        if case .yearly(let requested) = type { return min(12, max(1, requested)) }
        return 1
    }

    public init(type: CalendarType = .monthly, selection: Binding<TimeRange?>,
                previewDate: Date, calendar: Calendar,
                @ViewBuilder dayView: @escaping (Date, Calendar, Bool, DaySelection?) -> Day) {
        self.type = type
        self._selection = selection
        self.previewDate = previewDate
        self.calendar = calendar
        self.dayView = dayView
    }

    public var body: some View {
        let periods = displayedPeriods
        return content(periods: periods)
            .onGeometryChange(for: Double.self, of: { $0.size.width }) { width = $0 }
    }

    private var displayedPeriods: [CalendarPeriod] {
        let grid = CalendarGrid(calendar: calendar)
        switch type {
        case .weekly:
            let dates = grid.week(containing: previewDate)
            return [CalendarPeriod(month: previewDate, dates: dates)]
        case .monthly:
            let month = calendar.dateInterval(of: .month, for: previewDate)?.start ?? previewDate
            return [CalendarPeriod(month: month, dates: grid.month(containing: month))]
        case .yearly:
            return grid.months(inYearContaining: previewDate).map {
                CalendarPeriod(month: $0, dates: grid.month(containing: $0))
            }
        }
    }

    @ViewBuilder private func content(periods: [CalendarPeriod]) -> some View {
        let monthWidth = max(0, (width - Double(yearColumns - 1) * monthSpacing) / Double(yearColumns))
        let side = width > 0 ? monthWidth / Double(calendar.weekdaySymbols.count) : nil
        switch type {
        case .weekly, .monthly:
            if let period = periods.first { grid(period, side: side, periods: periods) }
        case .yearly:
            let rows = (periods.count + yearColumns - 1) / yearColumns
            let monthLength: CGFloat? = width > 0 ? CGFloat(monthWidth) : nil
            // A year is bounded to its calendar's months. Stacks allow the containing page to scroll.
            VStack(alignment: .leading, spacing: monthSpacing) {
                ForEach(0..<rows, id: \.self) { row in
                    HStack(alignment: .top, spacing: monthSpacing) {
                        ForEach(Array(periods[(row * yearColumns)..<min((row + 1) * yearColumns, periods.count)])) { period in
                            VStack {
                                Text(period.month.formatted(Date.FormatStyle(locale: calendar.locale ?? .current, calendar: calendar, timeZone: calendar.timeZone).month(.wide)))
                                    .font(.headline)
                                DefaultWeekdaysHeaderView(headerTextColor: .secondary, calendar: calendar)
                                grid(period, side: side, periods: periods)
                            }
                            .frame(width: monthLength)
                            .frame(maxWidth: monthLength == nil ? .infinity : nil)
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
            }
        }
    }

    private func grid(_ period: CalendarPeriod, side: Double?, periods: [CalendarPeriod]) -> some View {
        let columns = calendar.weekdaySymbols.count
        let rows = (period.dates.count + columns - 1) / columns
        // Each week row shares the size computed by the calendar container.
        return VStack(spacing: 0) {
            ForEach(0..<rows, id: \.self) { row in
                let id = CalendarRowID(period: period.id, row: row)
                HStack(spacing: 0) {
                    ForEach(Array(period.dates[(row * columns)..<min((row + 1) * columns, period.dates.count)]), id: \.self) { date in
                        dayCell(date, month: period.month, side: side)
                    }
                }
                .onGeometryChange(for: CGRect.self, of: { $0.frame(in: .global) }) { rowFrames[id] = $0 }
                .onDisappear { rowFrames.removeValue(forKey: id) }
                .id(id)
            }
        }
        .frame(maxWidth: .infinity)
        .id(period.id)
        #if !os(tvOS)
        .simultaneousGesture(DragGesture(minimumDistance: 4, coordinateSpace: .global)
            .onChanged { extendSelection(at: $0.location, periods: periods) })
        #endif
    }

    private func dayCell(_ date: Date, month: Date, side: Double?) -> some View {
        let length: CGFloat? = side.map { CGFloat($0) }
        let position = CalendarSelection(calendar: calendar).position(of: date, in: selection)
        return Button {
            selection = CalendarSelection(calendar: calendar).tapping(date, selection: selection, multiple: isMultiselectionEnabled)
        } label: {
            dayView(date, calendar, calendar.isDate(date, equalTo: month, toGranularity: .month), position)
                .environment(\.calendarDaySize, side)
                .frame(width: length, height: length)
                .componentHitArea(Rectangle())
        }
        .buttonStyle(.plain)
        .disabled(!isSelectionEnabled)
        .if(side == nil) { $0.aspectRatio(1, contentMode: .fit) }
        .accessibilityLabel(Text(date.formatted(Date.FormatStyle(locale: calendar.locale ?? .current, calendar: calendar, timeZone: calendar.timeZone).weekday(.wide).day().month(.wide).year())))
        .accessibilityAddTraits(position == nil ? .componentEmpty : .isSelected)
    }

    private func extendSelection(at point: CGPoint, periods: [CalendarPeriod]) {
        guard isSelectionEnabled, isMultiselectionEnabled,
              point.x.isFinite, point.y.isFinite else { return }
        let columns = calendar.weekdaySymbols.count
        for period in periods {
            for row in 0..<((period.dates.count + columns - 1) / columns) {
                guard let frame = rowFrames[CalendarRowID(period: period.id, row: row)],
                      frame.contains(point), frame.width > 0 else { continue }
                let column = Int((point.x - frame.minX) / (frame.width / Double(columns)))
                let index = row * columns + column
                guard period.dates.indices.contains(index) else { return }
                let updated = CalendarSelection(calendar: calendar).extending(to: period.dates[index], selection: selection)
                if updated != selection { selection = updated }
                return
            }
        }
    }

    public func multiselectionEnabled(_ enabled: Bool) -> Self {
        var view = self
        view.isMultiselectionEnabled = enabled
        return view
    }

    public func selectionEnabled(_ enabled: Bool) -> Self {
        var view = self
        view.isSelectionEnabled = enabled
        return view
    }
}

private struct CalendarPeriod: Identifiable {
    let month: Date
    let dates: [Date]
    var id: Date { dates.first ?? month }
}

// Row bounds remain usable when Android clips a partially visible row to its scroll viewport.
struct CalendarRowID: Hashable {
    let period: Date
    let row: Int
}
