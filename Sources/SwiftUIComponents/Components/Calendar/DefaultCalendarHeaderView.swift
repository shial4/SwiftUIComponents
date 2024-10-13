import SwiftUI

/// A view representing the default calendar header view.
public struct DefaultCalendarHeaderView: View {
    private var formatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM yyyy"
        formatter.locale = calendar.locale
        return formatter
    }
    
    @Binding var previewDate: Date
    var type: CalendarType
    let colorSet: CalendarColorSet
    let calendar: Calendar
    
    /// Initializes a new instance of the default calendar header view.
    /// - Parameters:
    ///   - date: The binding to the preview date.
    ///   - calendar: The calendar to be used.
    ///   - type: The calendar type.
    ///   - colorSet: The color set for the header view.
    public init(
        _ date: Binding<Date>,
        calendar: Calendar,
        type: CalendarType,
        colorSet: CalendarColorSet = DefaultCalendarColorSet()
    ) {
        self._previewDate = date
        self.calendar = calendar
        self.colorSet = colorSet
        self.type = type
    }
    
    public var body: some View {
        HStack {
            Button(action: previousTimePeriod) {
                Chevron(thickness: 0.25)
                    .fill(colorSet.headerButtonColors)
                    .frame(width: 12, height: 18)
                    .rotationEffect(Angle(degrees: 180))
                    .padding(8)
                    .contentShape(Rectangle())
            }
            .buttonStyle(PlainButtonStyle())
            
            Spacer()
            
            Text(previewDate, formatter: formatter)
                .font(Font.system(Font.TextStyle.body).weight(Font.Weight.semibold))
                .lineLimit(1)
                .foregroundColor(colorSet.headerButtonColors)
            
            Spacer()
            
            Button(action: nextTimePeriod) {
                Chevron(thickness: 0.25)
                    .fill(colorSet.headerButtonColors)
                    .frame(width: 12, height: 18)
                    .padding(8)
                    .contentShape(Rectangle())
            }
            .buttonStyle(PlainButtonStyle())
        }
    }
    
    // MARK: Button Actions
    private func previousTimePeriod() {
        switch type {
        case .yearly:
            previewDate = calendar.date(byAdding: Calendar.Component.year, value: -1, to: previewDate) ?? previewDate
        case .monthly:
            previewDate = calendar.date(byAdding: Calendar.Component.month, value: -1, to: previewDate) ?? previewDate
        case .weekly:
            previewDate = calendar.date(byAdding: Calendar.Component.day, value: -7, to: previewDate) ?? previewDate
        }
    }
    
    private func nextTimePeriod() {
        switch type {
        case .yearly:
            previewDate = calendar.date(byAdding: Calendar.Component.year, value: 1, to: previewDate) ?? previewDate
        case .monthly:
            previewDate = calendar.date(byAdding: Calendar.Component.month, value: 1, to: previewDate) ?? previewDate
        case .weekly:
            previewDate = calendar.date(byAdding: Calendar.Component.day, value: 7, to: previewDate) ?? previewDate
        }
    }
}

struct DefaultCalendarHeaderView_Previews: PreviewProvider {
    static var previews: some View {
        DefaultCalendarHeaderView(.constant(Date()), calendar: Calendar(identifier: .gregorian), type: .monthly)
    }
}
