import SwiftUI

/// A calendar title with previous, next and return-to-today controls.
public struct DefaultCalendarHeaderView: View {
    @Binding private var previewDate: Date
    private let type: CalendarType
    private let colorSet: any CalendarColorSet
    private let calendar: Calendar

    public init(_ date: Binding<Date>, calendar: Calendar, type: CalendarType,
                colorSet: any CalendarColorSet = DefaultCalendarColorSet()) {
        self._previewDate = date
        self.calendar = calendar
        self.colorSet = colorSet
        self.type = type
    }

    private var component: Calendar.Component {
        switch type {
        case .yearly: .year
        case .monthly: .month
        case .weekly: .weekOfYear
        }
    }

    public var body: some View {
        HStack {
            Button("Previous period", systemImage: "chevron.left") { move(-1) }
                .labelStyle(.iconOnly)
            Spacer(minLength: 0)
            Text(previewDate.formatted(Date.FormatStyle(locale: calendar.locale ?? .current,
                                                       calendar: calendar, timeZone: calendar.timeZone)
                .month(.wide).year()))
                .font(.headline)
                .foregroundStyle(colorSet.headerTitleColor)
            Spacer(minLength: 0)
            if !calendar.isDate(previewDate, equalTo: Date(), toGranularity: component) {
                Button("Today") { previewDate = calendar.startOfDay(for: Date()) }
            }
            Button("Next period", systemImage: "chevron.right") { move(1) }
                .labelStyle(.iconOnly)
        }
        .buttonStyle(.plain)
        .foregroundStyle(colorSet.headerButtonColors)
        .padding(.vertical, 8)
    }

    private func move(_ direction: Int) {
        previewDate = calendar.date(byAdding: component, value: direction, to: previewDate) ?? previewDate
    }
}
