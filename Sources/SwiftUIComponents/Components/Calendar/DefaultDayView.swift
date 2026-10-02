import SwiftUI

public enum DaySelection: Equatable, Sendable {
    case leading, trailing, inner, single
}

/// A day number with a selection background and optional event indicator.
public struct DefaultDayView: View {
    @Environment(\.calendarDaySize) var calendarDaySize
    private let date: Date
    private let calendar: Calendar
    private let isDateInMonth: Bool
    private let isSelected: DaySelection?
    private let contentColor: Color?
    private let colorSet: any CalendarColorSet
    private let size: Double?

    public init(date: Date, calendar: Calendar, isDateInMonth: Bool, isSelected: DaySelection?,
                colorSet: any CalendarColorSet = DefaultCalendarColorSet(), contentColor: Color? = nil,
                size: Double? = nil) {
        self.date = date
        self.calendar = calendar
        self.isDateInMonth = isDateInMonth
        self.isSelected = isSelected
        self.colorSet = colorSet
        self.contentColor = contentColor
        self.size = size.map { $0.isFinite ? max(0, $0) : 0 }
    }

    var textColor: Color {
        if !isDateInMonth { return colorSet.otherDateColor }
        if calendar.isDateInToday(date) { return colorSet.todayColor }
        switch calendar.component(.weekday, from: date) {
        case 1: return colorSet.sundayColor
        case 7: return colorSet.saturdayColor
        default: return colorSet.weekdayColor
        }
    }

    public var body: some View {
        let side = size ?? calendarDaySize
        let length: CGFloat? = side.map { CGFloat($0) }
        Text(date.formatted(Date.FormatStyle(locale: calendar.locale ?? .current,
                                              calendar: calendar, timeZone: calendar.timeZone).day()))
            .fontWeight(calendar.isDateInWeekend(date) || calendar.isDateInToday(date) ? .semibold : .regular)
            .foregroundStyle(textColor)
            .frame(width: length, height: length)
            .if(side == nil) {
                $0.frame(maxWidth: .infinity, maxHeight: .infinity)
                    .aspectRatio(1, contentMode: .fit)
            }
            .background(isSelected == nil ? .clear : colorSet.selectionColor)
            .overlay(alignment: .bottom) {
                if let contentColor {
                    Circle().fill(contentColor).frame(width: 5, height: 5).padding(.bottom, 2)
                }
            }
    }
}

/// The calendar measures its width once and shares the derived cell size with every day.
private struct CalendarDaySizeKey: EnvironmentKey {
    static let defaultValue: Double? = nil
}

extension EnvironmentValues {
    var calendarDaySize: Double? {
        get { self[CalendarDaySizeKey.self] }
        set { self[CalendarDaySizeKey.self] = newValue }
    }
}
