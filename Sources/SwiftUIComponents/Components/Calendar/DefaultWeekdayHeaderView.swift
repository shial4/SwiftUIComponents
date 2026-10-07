import SwiftUI

/// A view representing the default weekdays header view.
public struct DefaultWeekdaysHeaderView: View {
    private let headerTextColor: Color

    private let calendar: Calendar

    /// Initializes a new instance of the default weekdays header view.
    /// - Parameters:
    ///   - headerTextColor: The color of the header text.
    ///   - calendar: The calendar to be used.
    public init(headerTextColor: Color, calendar: Calendar) {
        self.headerTextColor = headerTextColor
        self.calendar = calendar
    }

    public var body: some View {
        let symbols = calendar.shortWeekdaySymbols
        return HStack {
            ForEach(symbols.indices, id: \.self) { index in
                Text(symbols[(calendar.firstWeekday - 1 + index) % symbols.count])
                #if !os(Android)
                    .fontWidth(.compressed)
                #endif
                    .frame(maxWidth: Double.infinity)
                    .foregroundStyle(headerTextColor)
                    .font(Font.system(Font.TextStyle.callout).weight(Font.Weight.light))
                    .lineLimit(1)
            }
        }
    }
}

#if !os(Android)
struct DefaultWeekdaysHeaderView_Previews: PreviewProvider {
    static var previews: some View {
        var calendar = Calendar(identifier: .gregorian)
        calendar.firstWeekday = 3
        return DefaultWeekdaysHeaderView(headerTextColor: .white, calendar: calendar)
    }
}
#endif
