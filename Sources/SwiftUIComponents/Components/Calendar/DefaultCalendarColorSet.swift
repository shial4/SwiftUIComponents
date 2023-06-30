import SwiftUI

/// A protocol defining a set of colors used in a calendar view.
public protocol CalendarColorSet {
    var todayColor: Color { get }
    var sundayColor: Color { get }
    var saturdayColor: Color { get }
    var weekdayColor: Color { get }
    var selectionColor: Color { get }
    var otherDateColor: Color { get }
    var weekdayHeaderColor: Color { get }
    var headerButtonColors: Color { get }
}

/// A default implementation of the `CalendarColorSet` protocol.
public struct DefaultCalendarColorSet: CalendarColorSet {
    public init() {}
}

extension CalendarColorSet {
    public var todayColor: Color { .blue }
    public var sundayColor: Color { .red }
    public var saturdayColor: Color { .gray }
    public var weekdayColor: Color { .white }
    public var selectionColor: Color { .green.opacity(0.4) }
    public var otherDateColor: Color { .gray.opacity(0.6) }
    public var weekdayHeaderColor: Color { .white }
    public var headerButtonColors: Color { .white }
}
