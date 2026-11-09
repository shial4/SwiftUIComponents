import Foundation
import Testing
import SwiftUI
@testable import SwiftUIComponents

func gregorian(_ zone: String = "UTC", firstWeekday: Int = 2) -> Calendar {
    var calendar = Calendar(identifier: .gregorian)
    calendar.timeZone = TimeZone(identifier: zone) ?? .gmt
    calendar.locale = Locale(identifier: "en_US_POSIX")
    calendar.firstWeekday = firstWeekday
    return calendar
}

func date(_ year: Int, _ month: Int, _ day: Int, hour: Int = 0, calendar: Calendar) throws -> Date {
    try #require(calendar.date(from: DateComponents(year: year, month: month, day: day, hour: hour)))
}

@Suite("Calendar arithmetic and selection")
struct CalendarTests {
    @MainActor @Test("Replacing a calendar grid releases the previous snapshot; destroying the cache releases the last one")
    func gridLifetime() throws {
        var cache: CalendarGridCache? = CalendarGridCache()
        let calendar = gregorian()
        let preview = try date(2024, 1, 1, calendar: calendar)
        weak var previous: CalendarGridCache.Snapshot?
        for month in 0..<120 {
            let next = try #require(calendar.date(byAdding: .month, value: month, to: preview))
            let snapshot = try #require(cache?.snapshot(calendar: calendar, date: next, type: .yearly(3)))
            #expect(previous == nil, "Navigating dates must not retain historical grids")
            previous = snapshot
        }
        #expect(previous != nil)
        cache = nil
        #expect(previous == nil, "The current grid must not outlive its view-owned cache")
    }

    @MainActor @Test("Calendar grids are reused until their date, mode or calendar changes")
    func gridReuse() throws {
        let cache = CalendarGridCache()
        let calendar = gregorian()
        let preview = try date(2024, 2, 29, calendar: calendar)
        let first = cache.snapshot(calendar: calendar, date: preview, type: .yearly(3))
        for _ in 0..<100 {
            #expect(cache.snapshot(calendar: calendar, date: preview, type: .yearly(3)) === first)
        }
        var sundayFirst = calendar
        sundayFirst.firstWeekday = 1
        for (updatedCalendar, updatedDate, type) in [
            (calendar, preview, CalendarType.monthly),
            (calendar, preview, .weekly),
            (calendar, try date(2025, 2, 28, calendar: calendar), .yearly(3)),
            (sundayFirst, preview, .yearly(3)),
            (gregorian("America/New_York"), preview, .yearly(3)),
            (Calendar(identifier: .hebrew), preview, .yearly(3))
        ] {
            let snapshot = cache.snapshot(calendar: updatedCalendar, date: updatedDate, type: type)
            let expected = CalendarGrid(calendar: updatedCalendar).periods(containing: updatedDate, type: type)
            #expect(snapshot !== first)
            #expect(snapshot.periods.map(\.dates) == expected.map(\.dates))
            #expect(snapshot.periods.map(\.month) == expected.map(\.month))
        }
        let restored = cache.snapshot(calendar: calendar, date: preview, type: .yearly(3))
        #expect(restored !== first, "Only the current grid is retained")
        #expect(restored.periods.map(\.dates) == first.periods.map(\.dates))
    }

    @Test("Month grids contain every day, aligned to the first weekday", arguments: [1, 2, 3, 7])
    func monthGrid(firstWeekday: Int) throws {
        let calendar = gregorian(firstWeekday: firstWeekday)
        let preview = try date(2024, 2, 29, hour: 15, calendar: calendar)
        let days = CalendarGrid(calendar: calendar).month(containing: preview)
        #expect(days.count.isMultiple(of: 7))
        #expect(calendar.component(.weekday, from: try #require(days.first)) == firstWeekday)
        #expect(days.filter { calendar.component(.month, from: $0) == 2 }.count == 29)
        #expect(Set(days).count == days.count)
        #expect(days.allSatisfy { $0 == calendar.startOfDay(for: $0) })
    }

    @Test("Week follows the supplied calendar across a year boundary")
    func weekGrid() throws {
        let calendar = gregorian()
        let days = CalendarGrid(calendar: calendar).week(containing: try date(2025, 1, 1, calendar: calendar))
        #expect(days.count == 7)
        #expect(days.first == (try date(2024, 12, 30, calendar: calendar)))
        #expect(days.last == (try date(2025, 1, 5, calendar: calendar)))
    }

    @Test("Leap-year calendars include their extra month")
    func hebrewYear() throws {
        var calendar = Calendar(identifier: .hebrew)
        calendar.timeZone = .gmt
        let preview = try date(5784, 1, 1, calendar: calendar)
        let months = CalendarGrid(calendar: calendar).months(inYearContaining: preview)
        #expect(months.count == 13)
        #expect(Set(months).count == 13)
        #expect(months.allSatisfy { calendar.component(.day, from: $0) == 1 })
    }

    @Test("Inclusive day ranges cross daylight saving without skipping days")
    func daylightSaving() throws {
        let calendar = gregorian("America/New_York")
        let range = TimeRange(start: try date(2024, 3, 9, hour: 12, calendar: calendar),
                              end: try date(2024, 3, 11, hour: 12, calendar: calendar))
        let days = range.toArray(calendar: calendar)
        #expect(days.map { calendar.component(.day, from: $0) } == [9, 10, 11])
        #expect(range.span(calendar: calendar, units: [.day]) == 2)
        #expect(days[2].timeIntervalSince(days[1]) == 23 * 3600)
    }

    @Test("Single-day and reversed ranges have defined behavior")
    func rangeBoundaries() throws {
        let calendar = gregorian()
        let start = try date(2024, 1, 2, calendar: calendar)
        let end = try date(2024, 1, 4, calendar: calendar)
        let range = TimeRange(start: start, end: end)
        #expect(range.contains(start))
        #expect(range.contains(end))
        #expect(!range.contains(start.addingTimeInterval(-1)))
        #expect(TimeRange(start: start, end: start).toArray(calendar: calendar) == [start])
        #expect(TimeRange(start: end, end: start).toArray(calendar: calendar).isEmpty)
        #expect(!TimeRange(start: end, end: start).contains(end))
    }

    @Test("Taps start, extend, deselect and replace selections")
    func taps() throws {
        let calendar = gregorian()
        let rules = CalendarSelection(calendar: calendar)
        let first = try date(2024, 2, 10, calendar: calendar)
        let last = try date(2024, 2, 15, calendar: calendar)
        let single = rules.tapping(first, selection: nil, multiple: true)
        #expect(single == TimeRange(start: first, end: first))
        #expect(rules.tapping(first, selection: single, multiple: true) == nil)
        let range = rules.tapping(last, selection: single, multiple: true)
        #expect(range == TimeRange(start: first, end: last))
        #expect(rules.tapping(first, selection: range, multiple: true) == nil)
        #expect(rules.tapping(first, selection: TimeRange(start: last, end: last), multiple: true) == range)
        #expect(rules.tapping(last, selection: single, multiple: false) == TimeRange(start: last, end: last))
    }

    @Test("Drag extension grows the range and selection positions ignore time of day")
    func dragAndPositions() throws {
        let calendar = gregorian("Australia/Brisbane")
        let rules = CalendarSelection(calendar: calendar)
        let first = try date(2024, 2, 10, calendar: calendar)
        let last = try date(2024, 2, 15, calendar: calendar)
        let range = rules.extending(to: last, selection: rules.extending(to: first, selection: nil))
        #expect(range == TimeRange(start: first, end: last))
        #expect(rules.extending(to: first.addingTimeInterval(86400), selection: range) == range)
        #expect(rules.normalized(TimeRange(start: first.addingTimeInterval(3600), end: last.addingTimeInterval(3600))) == range)
        #expect(CalendarSelection.position(ofDay: first, in: range) == .leading)
        #expect(CalendarSelection.position(ofDay: last, in: range) == .trailing)
        #expect(CalendarSelection.position(ofDay: first.addingTimeInterval(86400), in: range) == .inner)
        #expect(CalendarSelection.position(ofDay: first.addingTimeInterval(-86400), in: range) == nil)
        #expect(CalendarSelection.position(ofDay: first, in: TimeRange(start: first, end: first)) == .single)
    }

    @Test("A grid-wide selection matches day boundaries across daylight saving", arguments: ["America/New_York", "Australia/Brisbane"])
    func normalizedGridSelection(timeZone: String) throws {
        let calendar = gregorian(timeZone)
        let rules = CalendarSelection(calendar: calendar)
        let start = try date(2024, 3, 9, hour: 12, calendar: calendar)
        let end = try date(2024, 3, 11, hour: 16, calendar: calendar)
        let selectedDays = rules.normalized(TimeRange(start: start, end: end))
        let grid = CalendarGrid(calendar: calendar).periods(containing: start, type: .monthly)
        let days = try #require(grid.first).dates
        let positions = days.compactMap { day -> (Int, DaySelection)? in
            CalendarSelection.position(ofDay: day, in: selectedDays).map {
                (calendar.component(.day, from: day), $0)
            }
        }
        #expect(positions.map(\.0) == [9, 10, 11])
        #expect(positions.map(\.1) == [.leading, .inner, .trailing])
        #expect(CalendarSelection.position(ofDay: start, in: nil) == nil)
        #expect(CalendarSelection.position(ofDay: start, in: rules.normalized(TimeRange(start: end, end: start))) == nil)
    }

    @Test("Month shifting clamps the day rather than overflowing February")
    func shiftMonth() throws {
        let calendar = gregorian()
        let january = try date(2024, 1, 31, hour: 14, calendar: calendar)
        let february = january.shiftToMonth(2, calendar: calendar)
        #expect(calendar.component(.month, from: february) == 2)
        #expect(calendar.component(.day, from: february) == 29)
        #expect(calendar.component(.hour, from: february) == 14)
        #expect(january.firstWeekday(calendar) == 2)
        #expect(january.compareDate(january.addingTimeInterval(3600), calendar: calendar))
        #expect(january.timeString(calendar) == "14:00")
    }

    @MainActor @Test("Native ClosedRange bindings remain readable and writable")
    func nativeRangeCompatibility() throws {
        let calendar = gregorian()
        let first = try date(2024, 2, 10, calendar: calendar)
        let last = try date(2024, 2, 12, calendar: calendar)
        let owner = RangeOwner()
        let binding = Binding(for: \RangeOwner.selection, on: owner)
        let mapped = binding.timeRange
        mapped.wrappedValue = TimeRange(start: first, end: last)
        #expect(owner.selection == first...last)
        #expect(mapped.wrappedValue == TimeRange(start: first, end: last))
        #expect(owner.selection?.toArray(calendar: calendar).count == 3)
        mapped.wrappedValue = nil
        #expect(owner.selection == nil)
    }

}

@MainActor final class RangeOwner { var selection: ClosedRange<Date>? }
