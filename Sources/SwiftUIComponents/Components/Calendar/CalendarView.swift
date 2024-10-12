import SwiftUI
import Foundation

/// Enum defining the type of calendar view.
public enum CalendarType {
    case yearly(Int), monthly, weekly
}

/// A customizable calendar view.
public struct CalendarView<Day, Weekday, Header>: View where Day: View, Weekday: View, Header: View {
    @Binding var date: Date
    @Binding var selection: ClosedRange<Date>?
    private let type: CalendarType
    private var colorSet: CalendarColorSet
    private var calendar: Calendar
    private var isMultiselectionEnabled: Bool = true
    private var isSelectionEnabled: Bool = true
    private var headerView: (_ date: Binding<Date>, _ calendar: Calendar) -> Header
    private var weekdaysView: (_ calendar: Calendar) -> Weekday
    private var dayView: (_ date: Date, _ calendar: Calendar, _ isDateInMonth: Bool, _ isSelected: DaySelection?) -> Day
    
    /// Initializes a calendar view with the specified parameters.
    ///
    /// - Parameters:
    ///   - date: A binding to the selected date.
    ///   - selection: A binding to the selected date range.
    ///   - calendar: The calendar to use for the view.
    ///   - type: The type of calendar view to display.
    ///   - headerView: A closure that returns the header view for the calendar view.
    ///   - weekdaysView: A closure that returns the weekdays view for the calendar view.
    ///   - dayView: A closure that returns the day view for the calendar view.
    internal init(date: Binding<Date>,
                  selection: Binding<ClosedRange<Date>?>,
                  calendar: Calendar,
                  type: CalendarType = .monthly,
                  colorSet: CalendarColorSet = DefaultCalendarColorSet(),
                  headerView: @escaping (_ date: Binding<Date>, _ calendar: Calendar) -> Header,
                  weekdaysView: @escaping (_ calendar: Calendar) -> Weekday,
                  dayView: @escaping (_ date: Date, _ calendar: Calendar, _ isDateInMonth: Bool, _ isSelected: DaySelection?) -> Day) {
        self._date = date
        self._selection = selection
        self.calendar = calendar
        self.type = type
        self.colorSet = colorSet
        self.headerView = headerView
        self.weekdaysView = weekdaysView
        self.dayView = dayView
    }
    
    public var body: some View {
        let result = VStack {
            if case .yearly = type {
            } else {
                headerView($date, calendar)
                weekdaysView(calendar)
            }
            CalendarContentView<Day>(type: type,
                                     selection: $selection,
                                     previewDate: date,
                                     calendar: calendar,
                                     dayView: dayView)
            .selectionEnabled(isSelectionEnabled)
            .multiselectionEnabled(isMultiselectionEnabled)
        }
        .task {
            date = date.normalized()
        }
        return result
    }
}

// MARK: Modifiers

extension CalendarView {
    /// Sets the calendar used for the view.
    ///
    /// - Parameter calendar: The calendar to use.
    /// - Returns: A modified `CalendarView` with the specified calendar.
    public func calendar(_ calendar: Calendar) -> Self {
        var view = self
        view.calendar = calendar
        return view
    }
    
    /// Enables or disables multiselection in the calendar view.
    ///
    /// - Parameter enabled: A Boolean value indicating whether multiselection should be enabled.
    /// - Returns: A modified `CalendarView` with multiselection enabled or disabled.
    public func multiselectionEnabled(_ enabled: Bool) -> Self {
        var view = self
        view.isSelectionEnabled = enabled
        return view
    }
    
    /// Enables or disables date selection in the calendar view.
    ///
    /// - Parameter enabled: A Boolean value indicating whether date selection should be enabled.
    /// - Returns: A modified `CalendarView` with date selection enabled or disabled.
    public func selectionEnabled(_ enabled: Bool) -> Self {
        var view = self
        view.isMultiselectionEnabled = enabled
        return view
    }
    
    /// Sets a custom header view for the calendar view.
    ///
    /// - Parameter headerView: A closure that returns the custom header view.
    /// - Returns: A modified `CalendarView` with the custom header view.
    public func headerView<H: View>(@ViewBuilder _ headerView: @escaping (_ date: Binding<Date>, _ calendar: Calendar) -> H) -> CalendarView<Day, Weekday, H> {
        CalendarView<Day, Weekday, H>(date: $date, selection: $selection, calendar: calendar, headerView: headerView, weekdaysView: weekdaysView, dayView: dayView)
    }
    
    /// Sets a custom weekdays view for the calendar view.
    ///
    /// - Parameter weekdaysView: A closure that returns the custom weekdays view.
    /// - Returns: A modified `CalendarView` with the custom weekdays view.
    public func weekdaysView<W: View>(@ViewBuilder _ weekdaysView: @escaping (_ calendar: Calendar) -> W) -> CalendarView<Day, W, Header> {
        CalendarView<Day, W, Header>(date: $date, selection: $selection, calendar: calendar, headerView: headerView, weekdaysView: weekdaysView, dayView: dayView)
    }
    
    /// Sets a custom day view for the calendar view.
    ///
    /// - Parameter dayView: A closure that returns the custom day view.
    /// - Returns: A modified `CalendarView` with the custom day view.
    public func dayView<D: View>(@ViewBuilder _ dayView: @escaping (_ date: Date, _ calendar: Calendar, _ isDateInMonth: Bool, _ isSelected: DaySelection?) -> D) -> CalendarView<D, Weekday, Header> {
        CalendarView<D, Weekday, Header>(date: $date, selection: $selection, calendar: calendar, headerView: headerView, weekdaysView: weekdaysView, dayView: dayView)
    }
}

// MARK: Default initialisers
#if !SKIP
extension CalendarView where Day == DefaultDayView, Header == DefaultCalendarHeaderView, Weekday == DefaultWeekdaysHeaderView {
    /// Initializes a calendar view with default configurations.
    ///
    /// - Parameters:
    ///   - date: A binding to the selected date.
    ///   - selection: A binding to the selected date range.
    ///   - calendar: The calendar to use for the view.
    ///   - type: The type of calendar view to display.
    ///   - colorSet: The color set to use for the calendar view.
    ///   - contentColorIndicator: A closure that returns the content color for a specific date.
    public init(date: Binding<Date>,
                selection: Binding<ClosedRange<Date>?> = .constant(nil),
                calendar: Calendar = Calendar(identifier: .gregorian),
                type: CalendarType = .monthly,
                colorSet: CalendarColorSet = DefaultCalendarColorSet(),
                contentColorIndicator: @escaping (_ date: Date) -> Color? = {_ in return nil }) {
        self.init(date: date,
                  selection: selection,
                  calendar: calendar,
                  type: type,
                  headerView: { date, calendar in
            DefaultCalendarHeaderView(date,
                                      calendar: calendar,
                                      type: type,
                                      colorSet: colorSet)
        }, weekdaysView: { calendar in
            DefaultWeekdaysHeaderView(headerTextColor: colorSet.weekdayHeaderColor,
                                      calendar: calendar)
        }) { date, calendar, isDateInMonth, isSelected in
            DefaultDayView(date: date,
                           calendar: calendar,
                           isDateInMonth: isDateInMonth,
                           isSelected: isSelected,
                           colorSet: colorSet,
                           contentColor: contentColorIndicator(date))
        }
    }
}
#endif
