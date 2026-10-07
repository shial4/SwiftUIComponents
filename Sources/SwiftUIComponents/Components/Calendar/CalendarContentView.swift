import SwiftUI

/// A calendar grid that supports individual selection, range selection and drag extension.
public struct CalendarContentView<Day: View>: View {
    @Binding private var selection: TimeRange?
    @State var width: Double = 0
    @State var rowGeometry = CalendarRowGeometry()
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
        let periods = CalendarGrid(calendar: calendar).periods(containing: previewDate, type: type)
        let selectedDays = CalendarSelection(calendar: calendar).normalized(selection)
        return content(periods: periods, selectedDays: selectedDays)
            .onGeometryChange(for: Double.self, of: { $0.size.width }) { if width != $0 { width = $0 } }
            #if !os(tvOS)
            .simultaneousGesture(DragGesture(minimumDistance: 0, coordinateSpace: .global)
                .onChanged { value in
                    guard hypot(value.translation.width, value.translation.height) >= 4 else { return }
                    // Preserve the touch-down day when the first move crosses a cell.
                    if selection == nil { extendSelection(at: value.startLocation, periods: periods) }
                    extendSelection(at: value.location, periods: periods)
                })
            #endif
    }

    @ViewBuilder private func content(periods: [CalendarPeriod], selectedDays: TimeRange?) -> some View {
        let monthWidth = max(0, (width - Double(yearColumns - 1) * monthSpacing) / Double(yearColumns))
        let side = width > 0 ? monthWidth / Double(calendar.weekdaySymbols.count) : nil
        switch type {
        case .weekly, .monthly:
            if let period = periods.first { grid(period, side: side, selectedDays: selectedDays) }
        case .yearly:
            let rows = (periods.count + yearColumns - 1) / yearColumns
            let monthLength: CGFloat? = width > 0 ? CGFloat(monthWidth) : nil
            // A year is bounded to its calendar's months. Stacks allow the containing page to scroll.
            VStack(alignment: .leading, spacing: monthSpacing) {
                ForEach(0..<rows, id: \.self) { row in
                    HStack(alignment: .top, spacing: monthSpacing) {
                        ForEach(periods[(row * yearColumns)..<min((row + 1) * yearColumns, periods.count)]) { period in
                            VStack {
                                Text(period.month.formatted(Date.FormatStyle(locale: calendar.locale ?? .current, calendar: calendar, timeZone: calendar.timeZone).month(.wide)))
                                    .font(.headline)
                                DefaultWeekdaysHeaderView(headerTextColor: .secondary, calendar: calendar)
                                grid(period, side: side, selectedDays: selectedDays)
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

    private func grid(_ period: CalendarPeriod, side: Double?, selectedDays: TimeRange?) -> some View {
        let columns = calendar.weekdaySymbols.count
        let rows = (period.dates.count + columns - 1) / columns
        // Each week row shares the size computed by the calendar container.
        return VStack(spacing: 0) {
            ForEach(0..<rows, id: \.self) { row in
                let id = CalendarRowID(period: period.id, row: row)
                HStack(spacing: 0) {
                    ForEach(period.dates[(row * columns)..<min((row + 1) * columns, period.dates.count)], id: \.self) { date in
                        dayCell(date, month: period.month, side: side, selectedDays: selectedDays)
                    }
                }
                .onGeometryChange(for: CGRect.self, of: { $0.frame(in: .global) }) {
                    rowGeometry.frames[id] = $0
                }
                .onDisappear { rowGeometry.frames.removeValue(forKey: id) }
                .id(id)
            }
        }
        .frame(maxWidth: .infinity)
        .id(period.id)
    }

    private func dayCell(_ date: Date, month: Date, side: Double?, selectedDays: TimeRange?) -> some View {
        let length: CGFloat? = side.map { CGFloat($0) }
        let position = CalendarSelection.position(ofDay: date, in: selectedDays)
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
                // Read geometry only during interaction, so scrolling does not invalidate every day.
                guard let frame = rowGeometry.frames[CalendarRowID(period: period.id, row: row)],
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

// Row bounds remain usable when Android clips a partially visible row to its scroll viewport.
struct CalendarRowID: Hashable {
    let period: Date
    let row: Int
}

// Geometry is gesture input, not rendered state. Keep its lifetime tied to the view
// without invalidating the calendar when global row positions change during scrolling.
@MainActor final class CalendarRowGeometry {
    var frames: [CalendarRowID: CGRect] = [:]
}
