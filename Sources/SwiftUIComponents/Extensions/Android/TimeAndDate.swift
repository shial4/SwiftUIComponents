#if SKIP

extension Calendar {
    
    // The first day of the week for the calendar.
    var firstWeekday: Int { 2 }
    
    // Returns the first moment of a given Date, as a Date.
    public func startOfDay(for date: Date) -> Date {
        let components = self.dateComponents(
            [
                Calendar.Component.year,
                Calendar.Component.month,
                Calendar.Component.day
            ], from: date)
        return self.date(from: components) ?? date
    }
    
    // Custom implementation of ordinality (since the method isn't available)
    public func ordinality(
        of smaller: Calendar.Component,
        in larger: Calendar.Component,
        for date: Date
    ) -> Int? {
        switch (smaller, larger) {
        case (.day, .year):
            // Find the day of the year
            return self.ordinalDayOfYear(for: date)
        case (.weekOfYear, .year):
            // Find the week of the year
            return self.component(Calendar.Component.weekOfYear, from: date)
        case (.day, .month):
            // Find the day of the month
            return self.component(Calendar.Component.day, from: date)
        default:
            return nil
        }
    }
    
    // Helper function to calculate the day of the year
    private func ordinalityDayOfYear(for date: Date) -> Int? {
        // Create components for start of the year and compare with given date
        let year = self.component(Calendar.Component.year, from: date)
        var startOfYearComponents = DateComponents()
        startOfYearComponents.year = year
        startOfYearComponents.month = 1
        startOfYearComponents.day = 1
        
        guard let startOfYear = self.date(from: startOfYearComponents) else { return nil }
        let daysSinceStartOfYear = self.dateComponents([Calendar.Component.day], from: startOfYear, to: date).day
        return daysSinceStartOfYear != nil ? daysSinceStartOfYear! + 1 : nil
    }
    
    // Check if two dates are equal up to a given granularity
    public func isDate(
        _ date1: Date,
        equalTo date2: Date,
        toGranularity component: Calendar.Component
    ) -> Bool {
        switch component {
        case .year:
            let year1 = self.component(Calendar.Component.year, from: date1)
            let year2 = self.component(Calendar.Component.year, from: date2)
            return year1 == year2
        case .month:
            let year1 = self.component(Calendar.Component.year, from: date1)
            let year2 = self.component(Calendar.Component.year, from: date2)
            let month1 = self.component(Calendar.Component.month, from: date1)
            let month2 = self.component(Calendar.Component.month, from: date2)
            return year1 == year2 && month1 == month2
        case .day:
            let year1 = self.component(Calendar.Component.year, from: date1)
            let year2 = self.component(Calendar.Component.year, from: date2)
            let day1 = self.ordinality(of: Calendar.Component.day, in: Calendar.Component.year, for: date1)
            let day2 = self.ordinality(of: Calendar.Component.day, in: Calendar.Component.year, for: date2)
            return year1 == year2 && day1 == day2
        case .weekOfYear:
            let year1 = self.component(Calendar.Component.year, from: date1)
            let year2 = self.component(Calendar.Component.year, from: date2)
            let week1 = self.component(Calendar.Component.weekOfYear, from: date1)
            let week2 = self.component(Calendar.Component.weekOfYear, from: date2)
            return year1 == year2 && week1 == week2
        default:
            return false
        }
    }
    
    // Check if a given date is today
    public func isDateInToday(_ date: Date) -> Bool {
        let today = Date()
        return isDate(date, equalTo: today, toGranularity: .day)
    }
    
    /// Returns the range of absolute time values that a smaller calendar component can take on in a larger calendar component that includes the specified date.
    func range(of smaller: Calendar.Component, in larger: Calendar.Component, for date: Date) -> Range<Int>? {
        // Get the range for the specified components
        switch (smaller, larger) {
        case (.day, .month):
            // Find the number of days in the given month
            if let range = self.range(of: .day, in: .month, for: date) {
                return range.lowerBound..<range.upperBound
            }
        case (.month, .year):
            // Find the number of months in the given year (should always be 1 to 12)
            if let range = self.range(of: .month, in: .year, for: date) {
                return range.lowerBound..<range.upperBound
            }
        case (.hour, .day):
            // Find the number of hours in the given day (should always be 0 to 23)
            if let range = self.range(of: .hour, in: .day, for: date) {
                return range.lowerBound..<range.upperBound
            }
        case (.minute, .hour):
            // Find the number of minutes in the given hour (should always be 0 to 59)
            if let range = self.range(of: .minute, in: .hour, for: date) {
                return range.lowerBound..<range.upperBound
            }
        case (.second, .minute):
            // Find the number of seconds in the given minute (should always be 0 to 59)
            if let range = self.range(of: .second, in: .minute, for: date) {
                return range.lowerBound..<range.upperBound
            }
        default:
            return nil
        }
        return nil
    }
}
#endif
