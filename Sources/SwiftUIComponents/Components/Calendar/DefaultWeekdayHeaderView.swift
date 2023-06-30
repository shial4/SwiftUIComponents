import SwiftUI

/// A view representing the default weekdays header view.
public struct DefaultWeekdaysHeaderView: View {
    @State var headerTextColor: Color
    
    var calendar: Calendar
    
    var weekRange: [Int] {
        let firstWeekday = calendar.firstWeekday
        
        var symbols = calendar.shortWeekdaySymbols
        symbols = Array(symbols[firstWeekday-1..<symbols.count]) + symbols[0..<firstWeekday-1]
        return symbols.compactMap({ calendar.shortWeekdaySymbols.firstIndex(of: $0) })
    }
    
    /// Initializes a new instance of the default weekdays header view.
    /// - Parameters:
    ///   - headerTextColor: The color of the header text.
    ///   - calendar: The calendar to be used.
    public init(headerTextColor: Color, calendar: Calendar) {
        self._headerTextColor = State(initialValue: headerTextColor)
        self.calendar = calendar
    }
    
    public var body: some View {
        HStack {
            ForEach(weekRange, id: \.self) { index in
                Text(calendar.shortWeekdaySymbols[index])
                    .foregroundColor(headerTextColor)
                    .frame(maxWidth: .infinity)
            }
        }
    }
}

struct DefaultWeekdaysHeaderView_Previews: PreviewProvider {
    static var previews: some View {
        var calendar = Calendar(identifier: .gregorian)
        calendar.firstWeekday = 3
        return DefaultWeekdaysHeaderView(headerTextColor: .white, calendar: calendar)
    }
}
