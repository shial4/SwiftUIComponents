import Foundation

public extension Date {
    func compare(with date: Date, calendar: Calendar = Calendar(identifier: Calendar.Identifier.gregorian)) -> Bool {
        let components: Set<Calendar.Component> = [
            Calendar.Component.year,
            Calendar.Component.month,
            Calendar.Component.day
        ]
        let componentsLhs = calendar.dateComponents(components, from: self)
        let componentsRhs = calendar.dateComponents(components, from: date)
        return componentsLhs == componentsRhs
    }
    
    func normalized(_ calendar: Calendar = Calendar(identifier: Calendar.Identifier.gregorian)) -> Date {
        calendar.startOfDay(for: self)
    }
    
    // get weekday in which month starts
    func firstWeekday(_ calendar: Calendar) -> Int {
        var components = calendar.dateComponents([
            Calendar.Component.year,
            Calendar.Component.month,
            Calendar.Component.day,
            Calendar.Component.hour,
            Calendar.Component.minute,
            Calendar.Component.second
        ], from: self)
        components.day = 1
        components.hour = 0
        components.minute = 0
        components.second = 0
        let date = calendar.date(from: components) ?? self
        return calendar.component(Calendar.Component.weekday, from: date)
    }
    
    func shiftToMonth(_ month: Int, calendar: Calendar) -> Date {
        var components = calendar.dateComponents([
            Calendar.Component.year,
            Calendar.Component.month,
            Calendar.Component.day,
            Calendar.Component.hour,
            Calendar.Component.minute,
            Calendar.Component.second
        ], from: self)
        components.month = month
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
        return "\(hour):\(minute)"
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
