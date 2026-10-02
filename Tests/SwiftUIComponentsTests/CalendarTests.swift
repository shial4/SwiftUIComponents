import Foundation
import Testing
import SwiftUI
@testable import SwiftUIComponents

private func gregorian(_ zone: String = "UTC", firstWeekday: Int = 2) -> Calendar {
    var calendar = Calendar(identifier: .gregorian)
    calendar.timeZone = TimeZone(identifier: zone) ?? .gmt
    calendar.locale = Locale(identifier: "en_US_POSIX")
    calendar.firstWeekday = firstWeekday
    return calendar
}

private func date(_ year: Int, _ month: Int, _ day: Int, hour: Int = 0, calendar: Calendar) throws -> Date {
    try #require(calendar.date(from: DateComponents(year: year, month: month, day: day, hour: hour)))
}

@Suite("Calendar arithmetic and selection")
struct CalendarTests {
    @MainActor @Test("Day cells reserve square space and keep their event dot above the next row", arguments: [60, 100, 140])
    func dayCellLayout(side: Int) throws {
        let calendar = gregorian()
        let date = try date(2024, 2, 10, calendar: calendar)
        func day(size: Double?) -> DefaultDayView {
            DefaultDayView(date: date, calendar: calendar, isDateInMonth: true, isSelected: .single,
                           colorSet: RenderingCalendarColors(), contentColor: .blue, size: size)
        }
        let automatic = ImageRenderer(content: day(size: nil).frame(width: CGFloat(side)))
        automatic.scale = 1
        #expect(automatic.cgImage?.height == side)
        let view = VStack(spacing: 24) {
            day(size: Double(side))
            day(size: 60)
        }.background(.white)
        let renderer = ImageRenderer(content: view)
        renderer.scale = 1
        let image = try #require(renderer.cgImage)
        #expect(image.width == side)
        #expect(image.height == side + 24 + 60)
        var pixels = [UInt8](repeating: 0, count: image.width * image.height * 4)
        try pixels.withUnsafeMutableBytes { buffer in
            let context = try #require(CGContext(data: buffer.baseAddress, width: image.width, height: image.height,
                                                 bitsPerComponent: 8, bytesPerRow: image.width * 4,
                                                 space: CGColorSpaceCreateDeviceRGB(),
                                                 bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue))
            context.draw(image, in: CGRect(x: 0, y: 0, width: image.width, height: image.height))
        }
        // The whole gap must stay white; selection and event drawing cannot bleed into it.
        for y in side..<(side + 24) {
            for x in 0..<image.width {
                let offset = (y * image.width + x) * 4
                #expect(pixels[offset] > 240 && pixels[offset + 1] > 240 && pixels[offset + 2] > 240)
            }
        }
        let dot = ((side - 5) * image.width + image.width / 2) * 4
        #expect(pixels[dot + 2] > 200 && pixels[dot] < 100, "The event dot stays inside the first cell")
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
        #expect(rules.position(of: first.addingTimeInterval(3600), in: range) == .leading)
        #expect(rules.position(of: last, in: range) == .trailing)
        #expect(rules.position(of: first.addingTimeInterval(86400), in: range) == .inner)
        #expect(rules.position(of: first.addingTimeInterval(-86400), in: range) == nil)
        #expect(rules.position(of: first, in: TimeRange(start: first, end: first)) == .single)
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
        let view = CalendarView(date: .constant(first), selection: binding, calendar: calendar)
        #expect(ImageRenderer(content: view.frame(width: 350, height: 350)).cgImage != nil)
        mapped.wrappedValue = nil
        #expect(owner.selection == nil)
    }

    @MainActor @Test("Year rendering retains all months for unusual column counts", arguments: [-1, 0, 5, 20])
    func yearColumns(columns: Int) throws {
        let calendar = gregorian()
        var months: Set<Int> = []
        let view = CalendarContentView(type: .yearly(columns), selection: .constant(nil as TimeRange?),
                                       previewDate: try date(2024, 1, 1, calendar: calendar), calendar: calendar) { date, calendar, inMonth, _ in
            if inMonth { months.insert(calendar.component(.month, from: date)) }
            return Text("Day")
        }
        #expect(ImageRenderer(content: view.frame(width: 600, height: 4000)).cgImage != nil)
        #expect(months == Set(1...12))
    }

    @MainActor @Test("Custom builders retain week mode and disabled selection")
    func customBuildersRetainSettings() throws {
        let calendar = gregorian()
        var renderedDays: [Date] = []
        var enabledValues: [Bool] = []
        let view = CalendarView(date: .constant(try date(2024, 2, 10, calendar: calendar)),
                                calendar: calendar, type: .weekly)
            .selectionEnabled(false).multiselectionEnabled(false)
            .headerView { _, _ in Text("Custom header") }
            .weekdaysView { _ in Text("Custom weekdays") }
            .dayView { date, _, _, _ in
                DayProbe(date: date) { day, enabled in renderedDays.append(day); enabledValues.append(enabled) }
            }
        let image = ImageRenderer(content: view.frame(width: 350, height: 150)).cgImage
        #expect(image != nil)
        #expect(Set(renderedDays).count == 7)
        #expect(!enabledValues.isEmpty && enabledValues.allSatisfy { !$0 })
    }
}

private struct DayProbe: View {
    @Environment(\.isEnabled) private var enabled
    let date: Date
    let record: (Date, Bool) -> Void
    var body: some View {
        record(date, enabled)
        return Text("Day")
    }
}

@MainActor private final class RangeOwner { var selection: ClosedRange<Date>? }

private struct RenderingCalendarColors: CalendarColorSet {
    var todayColor: Color { .black }
    var sundayColor: Color { .black }
    var saturdayColor: Color { .black }
    var weekdayColor: Color { .black }
    var selectionColor: Color { .red }
    var otherDateColor: Color { .black }
    var weekdayHeaderColor: Color { .black }
    var headerTitleColor: Color { .black }
    var headerButtonColors: Color { .black }
}
