import SwiftUI
import SwiftUIComponents

enum CalendarPartSample: String, CaseIterable, Identifiable {
    case wrapper = "DefaultCalendarView", content = "CalendarContentView", day = "DefaultDayView"
    case header = "DefaultCalendarHeaderView", weekdays = "DefaultWeekdaysHeaderView"
    var id: Self { self }
    var detail: String {
        switch self {
        case .wrapper: "The complete calendar with default builders, custom colors and a bound selection."
        case .content: "Just the selectable grid. Supply your own day builder and surrounding chrome."
        case .day: "A standalone day cell with selection positions, weekend colors and an event dot."
        case .header: "Month navigation and return-to-today controls for your own calendar composition."
        case .weekdays: "Localized weekday names, reordered using the supplied calendar's first weekday."
        }
    }
    var code: String {
        switch self {
        case .wrapper: "DefaultCalendarView(date: $date, selection: $selection,\n    calendar: .current, type: .monthly)"
        case .content: "CalendarContentView(selection: $selection, previewDate: date,\n    calendar: .current) { date, calendar, inMonth, position in\n    DefaultDayView(date: date, calendar: calendar,\n        isDateInMonth: inMonth, isSelected: position)\n}"
        case .day: "DefaultDayView(date: date, calendar: .current,\n    isDateInMonth: true, isSelected: .single,\n    contentColor: .orange, size: 100)"
        case .header: "DefaultCalendarHeaderView($date, calendar: .current, type: .monthly)"
        case .weekdays: "DefaultWeekdaysHeaderView(headerTextColor: .purple, calendar: calendar)"
        }
    }
}

struct CalendarPartExampleView: View {
    let sample: CalendarPartSample
    @State var date = Date()
    @State var selection: TimeRange?
    @State var mondayFirst = true
    @State var selected = true
    @State var event = true
    @State var mode = 1
    private var calendar: Calendar {
        var calendar = Calendar.current
        calendar.firstWeekday = mondayFirst ? 2 : 1
        return calendar
    }
    private var type: CalendarType {
        switch mode { case 0: .weekly; case 2: .yearly(2); default: .monthly }
    }
    var body: some View {
        GeometryReader { proxy in
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    Text(sample.detail).foregroundStyle(.secondary)
                    if sample == .wrapper || sample == .content || sample == .header {
                        Picker("Calendar period", selection: $mode) {
                            Text("Week").tag(0); Text("Month").tag(1); Text("Year").tag(2)
                        }.pickerStyle(.segmented)
                    }
                    if sample == .wrapper || sample == .content {
                        Text("Selected days: \(selection?.toArray(calendar: calendar).count ?? 0)")
                    }
                    ExampleCard(sample.rawValue) { preview(width: max(0, proxy.size.width - 72)) }
                    if sample == .day {
                        Toggle("Selected", isOn: $selected)
                        Toggle("Event indicator", isOn: $event)
                    }
                    Toggle("Monday first", isOn: $mondayFirst)
                    if sample == .header { Text(date, format: .dateTime.day().month().year()) }
                    ExampleCode(code: sample.code)
                }.padding()
            }
        }
    }

    @ViewBuilder private func preview(width: Double) -> some View {
        switch sample {
        case .wrapper:
            DefaultCalendarView(date: $date, selection: $selection, calendar: calendar, type: type,
                                colorSet: DemoCalendarColors(), contentColorIndicator: { _ in .orange })
        case .content:
            CalendarContentView(type: type, selection: $selection, previewDate: date, calendar: calendar) {
                DefaultDayView(date: $0, calendar: $1, isDateInMonth: $2, isSelected: $3,
                               colorSet: DemoCalendarColors(), contentColor: .orange)
            }
        case .day:
            dayPreview(rangeSize: width / 5)
        case .header:
            DefaultCalendarHeaderView($date, calendar: calendar, type: type, colorSet: DemoCalendarColors())
                .frame(minHeight: 120)
        case .weekdays:
            VStack(spacing: 28) {
                DefaultWeekdaysHeaderView(headerTextColor: .purple, calendar: calendar)
                Text("First weekday: " + calendar.weekdaySymbols[calendar.firstWeekday - 1])
                    .font(.callout)
            }.frame(minHeight: 120)
        }
    }

    private func dayPreview(rangeSize: Double) -> some View {
        VStack(spacing: 24) {
            DefaultDayView(date: date, calendar: calendar, isDateInMonth: true,
                           isSelected: selected ? .single : nil, colorSet: DemoCalendarColors(),
                           contentColor: event ? .orange : nil, size: 100)
            HStack(spacing: 0) {
                ForEach(0..<5, id: \.self) { index in
                    DefaultDayView(date: calendar.date(byAdding: .day, value: index, to: date) ?? date,
                                   calendar: calendar, isDateInMonth: true,
                                   isSelected: index == 0 ? .leading : index == 4 ? .trailing : .inner,
                                   colorSet: DemoCalendarColors(), size: rangeSize)
                }
            }
            Text("Leading, inner and trailing cells form a range.").font(.caption)
        }.frame(maxWidth: .infinity)
    }
}
