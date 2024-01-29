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
    public var todayColor: Color { Color.blue }
    public var sundayColor: Color { Color.red }
    public var saturdayColor: Color { Color.red.opacity(0.6) }
    public var weekdayColor: Color { Color.white }
    public var selectionColor: Color { Color.green.opacity(0.4) }
    public var otherDateColor: Color { Color.white.opacity(0.25) }
    public var weekdayHeaderColor: Color { Color.white }
    public var headerButtonColors: Color { Color.white }
}
