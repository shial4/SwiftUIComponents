import SwiftUI
import SwiftUIComponents

struct CalendarExampleView: View {
    @State var date = Date()
    @State var selection: TimeRange?
    @State var mode = 1
    @State var multiple = true
    @State var selectionEnabled = true
    @State var mondayFirst = true
    @State var customDays = false

    private var calendar: Calendar {
        var calendar = Calendar.current
        calendar.firstWeekday = mondayFirst ? 2 : 1
        return calendar
    }
    private var type: CalendarType {
        switch mode { case 0: .weekly; case 2: .yearly(2); default: .monthly }
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                Picker("Period", selection: $mode) {
                    Text("Week").tag(0); Text("Month").tag(1); Text("Year").tag(2)
                }.pickerStyle(.segmented)
                Toggle("Select a date range", isOn: $multiple)
                Toggle("Enable selection", isOn: $selectionEnabled)
                Toggle("Monday first", isOn: $mondayFirst)
                Toggle("Custom day cells", isOn: $customDays)
                if customDays {
                    configuredCalendar.dayView { date, calendar, inMonth, position in
                        VStack(spacing: 0) {
                            Text("\(calendar.component(.day, from: date))")
                            if calendar.isDateInWeekend(date) { Circle().fill(.orange).frame(width: 4, height: 4) }
                        }
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .foregroundStyle(inMonth ? Color.primary : .secondary)
                        .background(position == nil ? .clear : Color.purple.opacity(0.25))
                    }
                    .headerView { date, _ in
                        HStack {
                            Button("Previous") { date.wrappedValue = calendar.date(byAdding: mode == 2 ? .year : mode == 0 ? .weekOfYear : .month, value: -1, to: date.wrappedValue) ?? date.wrappedValue }
                            Spacer()
                            Text(date.wrappedValue, format: .dateTime.month().year())
                            Spacer()
                            Button("Next") { date.wrappedValue = calendar.date(byAdding: mode == 2 ? .year : mode == 0 ? .weekOfYear : .month, value: 1, to: date.wrappedValue) ?? date.wrappedValue }
                        }
                    }
                } else { configuredCalendar }
                if let selection {
                    Text("\(selection.start, format: .dateTime.day().month()) - \(selection.end, format: .dateTime.day().month())")
                    Text("\(selection.toArray(calendar: calendar).count) selected calendar days")
                } else { Text("Tap a day, then another day to select a range. Drag across days to extend it.") }
                Button("Clear selection") { selection = nil }
                GroupBox("DefaultCalendarView convenience wrapper") {
                    DefaultCalendarView(date: $date, calendar: calendar, type: .weekly)
                        .multiselectionEnabled(false)
                }
                GroupBox("Standalone CalendarContentView") {
                    CalendarContentView(type: .weekly, selection: $selection, previewDate: date,
                                        calendar: calendar) { date, calendar, inMonth, position in
                        DefaultDayView(date: date, calendar: calendar, isDateInMonth: inMonth,
                                       isSelected: position, contentColor: .orange)
                    }
                }
            }.padding()
        }
    }

    private var configuredCalendar: CalendarView<DefaultDayView, DefaultWeekdaysHeaderView, DefaultCalendarHeaderView> {
        CalendarView(date: $date, selection: $selection, calendar: calendar, type: type,
                     colorSet: DemoCalendarColors(), contentColorIndicator: { date in
            calendar.component(.day, from: date).isMultiple(of: 5) ? .orange : nil
        })
        .multiselectionEnabled(multiple)
        .selectionEnabled(selectionEnabled)
    }
}

struct DemoCalendarColors: CalendarColorSet {
    var todayColor: Color { .purple }
    var sundayColor: Color { .red }
    var saturdayColor: Color { .orange }
    var weekdayColor: Color { .primary }
    var selectionColor: Color { .purple.opacity(0.25) }
    var otherDateColor: Color { .secondary }
    var weekdayHeaderColor: Color { .secondary }
    var headerTitleColor: Color { .purple }
    var headerButtonColors: Color { .purple }
}
