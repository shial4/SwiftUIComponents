import Foundation

extension ClosedRange where Bound == Date {
    func span(calendar: Calendar, units: Set<Calendar.Component>) -> Int {
        let date1 = calendar.startOfDay(for: lowerBound)
        let date2 = calendar.startOfDay(for: upperBound) 
        let components = calendar.dateComponents(units, from: date1, to: date2)
        return components.day ?? 0
    }
    
    func toArray(calendar: Calendar) -> [Date] {
        let date1 = calendar.startOfDay(for: lowerBound)
        let date2 = calendar.startOfDay(for: upperBound)
        let components = calendar.dateComponents([.day], from: date1, to: date2)
        let days = components.day ?? 0
        
        guard days > 0 else { return [date1] }
        
        var dates = [date1]
        for i in 1 ... days {
            if let nextDate = calendar.date(byAdding: .day, value: i, to: date1) {
                dates.append(nextDate)
            }
        }
        return dates
    }
}
