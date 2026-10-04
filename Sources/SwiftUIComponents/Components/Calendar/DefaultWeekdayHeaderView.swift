import SwiftUI

/// A view representing the default weekdays header view.
public struct DefaultWeekdaysHeaderView: View {
    private let headerTextColor: Color

    var calendar: Calendar

    var weekRange: [Int] {
        let firstWeekday = calendar.firstWeekday
        let symbols: [String] = calendar.shortWeekdaySymbols
        let reorderedSymbols: [Int] = (firstWeekday-1..<symbols.count).map { $0 } + (0..<firstWeekday-1).map { $0 }

        return reorderedSymbols
    }

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
            ForEach(weekRange, id: \.self) { index in
                Text(symbols[index])
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
