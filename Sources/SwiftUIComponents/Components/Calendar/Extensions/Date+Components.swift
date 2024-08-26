import Foundation

public extension Date {
    func compare(with date: Date, calendar: Calendar = Calendar(identifier: .gregorian)) -> Bool {
        let componentsLhs = calendar.dateComponents([.year, .month, .day], from: self)
        let componentsRhs = calendar.dateComponents([.year, .month, .day], from: date)
        return componentsLhs == componentsRhs
    }
    
    func normalized(_ calendar: Calendar = Calendar(identifier: .gregorian)) -> Date {
        calendar.startOfDay(for: self)
    }
    
    // get weekday in which month starts
    func firstWeekday(_ calendar: Calendar) -> Int {
        var components = calendar.dateComponents([.year, .month, .day, .hour, .minute, .second], from: self)
        components.day = 1
        components.hour = 0
        components.minute = 0
        components.second = 0
        let date = calendar.date(from: components) ?? self
        return calendar.component(.weekday, from: date)
    }
    
    func shiftToMonth(_ month: Int, calendar: Calendar) -> Date {
        var components = calendar.dateComponents([.year, .month, .day, .hour, .minute, .second], from: self)
        components.month = month
        return calendar.date(from: components) ?? self
    }
    
    func weekday(_ calendar: Calendar) -> Int {
        calendar.component(.weekday, from: self)
    }
    
    func day(_ calendar: Calendar) -> Int {
        calendar.component(.day, from: self)
    }
    
    func month(_ calendar: Calendar) -> Int {
        calendar.component(.month, from: self)
    }
    
    func year(_ calendar: Calendar) -> Int {
        calendar.component(.year, from: self)
    }
    
    func timeString(_ calendar: Calendar = Calendar.current) -> String {
        let hour = calendar.component(.hour, from: self)
        let minute = calendar.component(.minute, from: self)
        return "\(hour):\(minute)"
    }
    
    func dateString(_ calendar: Calendar = Calendar.current) -> String {
        "\(self.day(calendar)).\(self.month(calendar)).\(self.year(calendar))"
    }
    
    func isInCurrentWeek(calendar: Calendar = Calendar(identifier: .gregorian)) -> Bool {
        return calendar.isDate(self, equalTo: Date(), toGranularity: .weekOfYear)
    }
    
    func isInCurrentMonth(calendar: Calendar = Calendar(identifier: .gregorian)) -> Bool {
        return calendar.isDate(self, equalTo: Date(), toGranularity: .month)
    }
    
    func isInCurrentYear(calendar: Calendar = Calendar(identifier: .gregorian)) -> Bool {
        return calendar.isDate(self, equalTo: Date(), toGranularity: .year)
    }
}
