import SwiftUI

/// Represents the selection style for a day.
public enum DaySelection {
    case leading
    case trailing
    case inner
    case single
}

/// A view representing the default day view.
public struct DefaultDayView: View {
    private var formatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "d"
        formatter.locale = calendar.locale
        return formatter
    }
    
    var date: Date
    var calendar: Calendar
    var isDateInMonth: Bool
    var isSelected: DaySelection?
    var contentColor: Color?
    var colorSet: CalendarColorSet
    
    /// Initializes a new instance of the default day view.
    /// - Parameters:
    ///   - date: The date to be displayed.
    ///   - calendar: The calendar to be used.
    ///   - isDateInMonth: A Boolean value indicating whether the date is in the current month.
    ///   - isSelected: The selection style for the day.
    ///   - colorSet: The color set for the day.
    ///   - contentColor: The color for the content of the day.
    public init(
        date: Date,
        calendar: Calendar,
        isDateInMonth: Bool,
        isSelected: DaySelection?,
        colorSet: CalendarColorSet = DefaultCalendarColorSet(),
        contentColor: Color?
    ) {
        self.date = date
        self.calendar = calendar
        self.isDateInMonth = isDateInMonth
        self.isSelected = isSelected
        self.colorSet = colorSet
        self.contentColor = contentColor
    }
    
    public var body: some View {
        GeometryReader { proxy in
            dayTextView
                .padding(4)
                .if(contentColor != nil) { content in
                    content.overlay(alignment: Alignment.bottom, content: haloView)
                }
                .padding(4)
                .if(isSelected == .leading) { content in
                    content.background(
                        Rectangle()
                            .foregroundColor(colorSet.selectionColor)
                            .cornerRadius(12, corners: RectCorner.topLeft, RectCorner.bottomLeft)
                    )
                }
                .if(isSelected == .trailing) { content in
                    content.background(
                        Rectangle()
                            .foregroundColor(colorSet.selectionColor)
                            .cornerRadius(12, corners: RectCorner.topRight, RectCorner.bottomRight)
                    )
                }
                .if(isSelected == .single) { content in
                    content.background(
                        RoundedRectangle(cornerRadius: 12, style:  RoundedCornerStyle.continuous)
                            .foregroundColor(colorSet.selectionColor)
                    )
                }
                .if(isSelected == .inner) { content in
                    content.background(colorSet.selectionColor)
                }
                .frame(minWidth: 44, minHeight: 44)
                .if(proxy.size.height < 44 || proxy.size.width < 44) { content in
                    content.scaleEffect(x: proxy.size.width != 0 ? proxy.size.width / 44 : 1,
                                        y: proxy.size.height != 0 ? proxy.size.height / 44 : 1,
                                        anchor: UnitPoint.topLeading)
                }
        }
    }
    
    var dayTextView: some View {
        Text(date, formatter: formatter)
            .frame(maxWidth: Double.infinity, maxHeight: .infinity)
            .if(calendar.isDateInToday(date)) { content in
                content.foregroundColor(colorSet.todayColor)
            }
            .if(date.weekday(calendar) == 1 && isDateInMonth) { content in
                content.foregroundColor(colorSet.sundayColor)
            }
            .if(date.weekday(calendar) == 7 && isDateInMonth) { content in
                content.foregroundColor(colorSet.saturdayColor)
            }
            .if(isDateInMonth) { content in
                content.foregroundColor(colorSet.weekdayColor)
            }
            .if(!isDateInMonth) { content in
                content.foregroundColor(colorSet.otherDateColor)
            }
            .font(dayFont(date))
    }
    
    func haloView() -> some View {
        Circle()
            .foregroundColor(contentColor ?? Color.clear)
            .frame(width: 8, height: 8)
            .offset(y: 4)
    }
    
    private func dayFont(_ date: Date) -> Font? {
        if calendar.isDateInWeekend(date) {
            return Font.system(Font.TextStyle.body).weight(Font.Weight.semibold)
        } else if calendar.isDateInToday(date) {
            return Font.system(Font.TextStyle.body).weight(Font.Weight.semibold)
        }
        return Font.system(Font.TextStyle.body)
    }
}

struct DefaultDayView_Previews: PreviewProvider {
    static var previews: some View {
        var calendar = Calendar(identifier: .gregorian)
        calendar.locale = Locale(identifier: "en_GB")
        return DefaultDayView(date: Date(),
                              calendar: calendar,
                              isDateInMonth: true,
                              isSelected: nil,
                              colorSet: DefaultCalendarColorSet(),
                              contentColor: .orange)
    }
}
