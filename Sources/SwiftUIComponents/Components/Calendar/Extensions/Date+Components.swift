import Foundation

public extension Date {
    func compareDate(_ date: Date, calendar: Calendar = Calendar(identifier: Calendar.Identifier.gregorian)) -> Bool {
        calendar.isDate(self, inSameDayAs: date)
    }

    func normalized(_ calendar: Calendar = Calendar(identifier: Calendar.Identifier.gregorian)) -> Date {
        calendar.startOfDay(for: self)
    }

    // get weekday in which month starts
    func firstWeekday(_ calendar: Calendar) -> Int {
        let first = calendar.dateInterval(of: .month, for: self)?.start ?? self
        return calendar.component(.weekday, from: first)
    }

    func shiftToMonth(_ month: Int, calendar: Calendar) -> Date {
        var components = calendar.dateComponents([.era, .year, .month, .day, .hour, .minute, .second], from: self)
        let requestedDay = components.day ?? 1
        components.month = month
        components.day = 1
        guard let first = calendar.date(from: components),
              let days = calendar.range(of: .day, in: .month, for: first) else { return self }
        components.day = min(requestedDay, days.count)
        return calendar.date(from: components) ?? self
    }

    func weekday(_ calendar: Calendar) -> Int {
        calendar.component(Calendar.Component.weekday, from: self)
    }

    func day(_ calendar: Calendar) -> Int {
        calendar.component(Calendar.Component.day, from: self)
    }

    func month(_ calendar: Calendar) -> Int {
        calendar.component(Calendar.Component.month, from: self)
    }

    func year(_ calendar: Calendar) -> Int {
        calendar.component(Calendar.Component.year, from: self)
    }

    func timeString(_ calendar: Calendar = Calendar.current) -> String {
        let hour = calendar.component(Calendar.Component.hour, from: self)
        let minute = calendar.component(Calendar.Component.minute, from: self)
        return "\(hour):\(minute < 10 ? "0" : "")\(minute)"
    }

    func dateString(_ calendar: Calendar = Calendar.current) -> String {
        "\(self.day(calendar)).\(self.month(calendar)).\(self.year(calendar))"
    }

    func isInCurrentWeek(calendar: Calendar = Calendar(identifier: Calendar.Identifier.gregorian)) -> Bool {
        return calendar.isDate(self, equalTo: Date(), toGranularity: Calendar.Component.weekOfYear)
    }

    func isInCurrentMonth(calendar: Calendar = Calendar(identifier: Calendar.Identifier.gregorian)) -> Bool {
        return calendar.isDate(self, equalTo: Date(), toGranularity: Calendar.Component.month)
    }

    func isInCurrentYear(calendar: Calendar = Calendar(identifier: Calendar.Identifier.gregorian)) -> Bool {
        return calendar.isDate(self, equalTo: Date(), toGranularity: Calendar.Component.year)
    }
}
