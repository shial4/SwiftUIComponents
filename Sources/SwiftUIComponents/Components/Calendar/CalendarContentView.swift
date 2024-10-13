import SwiftUI

/// A view that displays the content of a calendar based on the specified `CalendarType`.
public struct CalendarContentView<Day>: View where Day: View {
    @Binding var selection: ClosedRange<Date>?
    @State private var hoverPoint: CGPoint? = nil
    private var isMultiselectionEnabled: Bool = true
    private var isSelectionEnabled: Bool = true
    
    var type: CalendarType
    var previewDate: Date
    var calendar: Calendar
    
    @ViewBuilder var dayView: (_ date: Date, _ calendar: Calendar, _ isDateInMonth: Bool, _ isSelected: DaySelection?) -> Day
    
    private var formatterMonth: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM"
        formatter.locale = calendar.locale
        return formatter
    }
    
    private var numberOfWeekdays: Int {
        return calendar.shortWeekdaySymbols.count
    }
    
    private var numberOfMonths: Int {
        guard let range = calendar.range(of: Calendar.Component.month, in: Calendar.Component.year, for: previewDate) else {
            return 0
        }
        return range.count
    }
    
    private var isSwipeGestureEnabled: Bool {
        isMultiselectionEnabled && isSelectionEnabled
    }
    
    /// Initializes a calendar content view with the specified parameters.
    ///
    /// - Parameters:
    ///   - type: The type of calendar view to display.
    ///   - selection: A binding to the selected date range.
    ///   - previewDate: The date to preview.
    ///   - calendar: The calendar to use for the view.
    ///   - dayView: A closure that returns the day view for the calendar content view.
    public init(type: CalendarType = .monthly,
                selection: Binding<ClosedRange<Date>?>,
                previewDate: Date,
                calendar: Calendar,
                dayView: @escaping (_ date: Date, _ calendar: Calendar, _ isDateInMonth: Bool, _ isSelected: DaySelection?) -> Day) {
        self.type = type
        self._selection = selection
        self.previewDate = previewDate
        self.calendar = calendar
        self.dayView = dayView
    }
    
    public var body: some View {
        Group {
            switch type {
            case .yearly(let columns):
                yearly(previewDate, columns: columns)
            case .monthly:
                monthly(previewDate)
            case .weekly:
                weekly
            }
        }
        .coordinateSpace(name: "calendar.coordinate.space")
    }
    
    private var weekly: some View {
        HStack(spacing: 0) {
            ForEach(1...7, id: \.self) { dayIndex in
                let date = date(for: dayIndex, in: 1, of: previewDate)
                dayView(date, calendar, true, selection(for: date))

                    .background( GeometryReader { proxy in
                        Rectangle()
                            .foregroundColor(Color.clear)
                            .onChange(of: hoverPoint, perform: { newValue in
                                if let value = newValue, proxy.frame(in: CoordinateSpace.named("calendar.coordinate.space")).contains(value) {
                                    updateSelectionIfNeeded(date)
                                }
                            })
                    })
                    .contentShape(Rectangle())
                    .gesture(isSelectionEnabled ? onDayTap(date) : nil)
            }
        }
        .gesture(isSwipeGestureEnabled ? onSwipe() : nil)
    }
    
    private func monthly(_ previewDate: Date) -> some View {
        let weeksCount = numberOfWeeks(of: previewDate)
        let remainingSpacers: Int = 6 - weeksCount
        return VStack(spacing: 0) {
            ForEach(0..<weeksCount, id: \.self) { weekIndex in
                HStack(spacing: 0) {
                    ForEach(1..<numberOfWeekdays + 1, id: \.self) { dayIndex in
                        let date = date(for: dayIndex, in: weekIndex, of: previewDate)
                        dayView(date, calendar, previewDate.month(calendar) == date.month(calendar), selection(for: date))
                            .background( GeometryReader { proxy in
                                Rectangle()
                                    .foregroundColor(Color.clear)
                                    .onChange(of: hoverPoint, perform: { newValue in
                                        if let value = newValue, proxy.frame(in: CoordinateSpace.named("calendar.coordinate.space")).contains(value) {
                                            updateSelectionIfNeeded(date)
                                        }
                                    })
                            })
                            .contentShape(Rectangle())
                            .gesture(isSelectionEnabled ? onDayTap(date) : nil)
                    }
                }
            }
            if remainingSpacers > 0 {
                ForEach(0..<remainingSpacers, id: \.self) { _ in
                    Spacer()
                        .frame(maxWidth: Double.infinity)
                }
            }
        }
        .gesture(isSwipeGestureEnabled ? onSwipe() : nil)
    }
    
    private func yearly(_ previewDate: Date, columns: Int) -> some View {
        VStack(alignment: HorizontalAlignment.leading, spacing: 0) {
            ForEach(0..<(numberOfMonths / columns), id: \.self) { rowIndex in
                HStack(alignment: VerticalAlignment.top, spacing: 0) {
                    ForEach(0..<columns, id: \.self) { columnIndex in
                        let month = rowIndex * columns + columnIndex + 1
                        let date = previewDate.shiftToMonth(month, calendar: calendar)
                        VStack(spacing: 0) {
                            Text(date, formatter: formatterMonth)
                                .lineLimit(1)
                            monthly(date)
                                .padding(Edge.Set.vertical, 8)
                                .padding(Edge.Set.horizontal, columns > 1 ? 8 : 0)
                        }
                    }
                }
            }
        }
    }
    
    // MARK: Gestures
    private func onSwipe() -> some Gesture {
        DragGesture(minimumDistance: 0,
                    coordinateSpace: CoordinateSpace.named("calendar.coordinate.space"))
            .onChanged({ value in
                hoverPoint = value.location
            }).onEnded({ value in
                hoverPoint = nil
            })
    }
    
    private func onDayTap(_ date: Date) -> some Gesture {
        TapGesture().onEnded {
            guard isMultiselectionEnabled, let oldSelection = selection else {
                selection = selection?.contains(date) == true ? nil : date...date
                return
            }
            
            if oldSelection.contains(date)
                || oldSelection.span(calendar: calendar, units: [Calendar.Component.day]) != 0 {
                selection = nil
            } else if oldSelection.lowerBound > date {
                selection = date...oldSelection.upperBound
            } else if oldSelection.upperBound < date {
                selection = oldSelection.lowerBound...date
            } else {
                selection = nil
            }
        }
    }
    
    // MARK: Private
    private func numberOfDays(of date: Date) -> Int {
        guard let range = calendar.range(of: Calendar.Component.day, in: Calendar.Component.month, for: date) else {
            return 0
        }
        return range.count
    }
    
    private func numberOfWeeks(of date: Date) -> Int {
        guard let range = calendar.range(of: Calendar.Component.weekOfMonth, in: Calendar.Component.month, for: date) else {
            return 0
        }
        return range.count
    }
    
    private func updateSelectionIfNeeded(_ date: Date, forceUpdate: Bool = false) {
        guard !forceUpdate, let oldSelection = selection else {
            selection = date...date
            return
        }
        
        if oldSelection.lowerBound > date {
            selection = date...oldSelection.upperBound
        } else if oldSelection.upperBound < date {
            selection = oldSelection.lowerBound...date
        }
    }
    
    private func selection(for date: Date) -> DaySelection? {
        guard let selection = selection else { return nil }
        let span = selection.span(calendar: calendar, units: [Calendar.Component.day])
        if selection.lowerBound.compare(with: date, calendar: calendar), span > 0 {
            return .leading
        } else if selection.upperBound.compare(with: date, calendar: calendar), span > 0 {
            return .trailing
        } else if selection.contains(date) {
            if span < 1 {
                return .single
            }
            return .inner
        }
        return nil
    }
    
    private func date(for day: Int, in week: Int, of date: Date) -> Date {
        let firstWeekday = calendar.firstWeekday
        let shift = date.firstWeekday(calendar)
        let currentDay = date.day(calendar)
        let offset: Int
        if shift - firstWeekday < 0 {
            offset = week * numberOfWeekdays + day - currentDay - (shift - firstWeekday) - 7
        } else {
            offset = week * numberOfWeekdays + day - currentDay - (shift - firstWeekday)
        }
        return calendar.date(byAdding: Calendar.Component.day, value: offset, to: date) ?? date
    }
}

// MARK: Modifiers

extension CalendarContentView {
    /// Enables or disables multiselection in the calendar content view.
    ///
    /// - Parameter enabled: A Boolean value that indicates whether multiselection is enabled. `true` to enable multiselection, `false` to disable it.
    /// - Returns: The modified calendar content view.
    public func multiselectionEnabled(_ enabled: Bool) -> Self {
        var view = self
        view.isSelectionEnabled = enabled
        return view
    }
    
    /// Enables or disables selection in the calendar content view.
    ///
    /// - Parameter enabled: A Boolean value that indicates whether selection is enabled. `true` to enable selection, `false` to disable it.
    /// - Returns: The modified calendar content view.
    public func selectionEnabled(_ enabled: Bool) -> Self {
        var view = self
        view.isMultiselectionEnabled = enabled
        return view
    }
}

struct CalendarContentView_Previews: PreviewProvider {
    static var previews: some View {
        CalendarContentView(selection: .constant(nil), previewDate: Date(), calendar: Calendar(identifier: .gregorian)) { date, calendar, isDateInMonth, isSelected in
            DefaultDayView(date: date,
                           calendar: calendar,
                           isDateInMonth: isDateInMonth,
                           isSelected: isSelected,
                           colorSet: DefaultCalendarColorSet(),
                           contentColor: .orange)
        }
    }
}
