import Foundation
import Testing
import SwiftUI
#if os(macOS)
import AppKit
#endif
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

extension HostedRenderingTests {
    #if os(macOS)
    @MainActor @Test("Scrolling a year does not reconstruct unchanged day views")
    func scrollingDoesNotRebuildDays() async throws {
        _ = NSApplication.shared
        let calendar = gregorian()
        let preview = try date(2026, 1, 1, calendar: calendar)
        var dayBuilds = 0
        let content = ScrollView {
            CalendarContentView(type: .yearly(3), selection: .constant(nil as TimeRange?),
                                previewDate: preview, calendar: calendar) { date, calendar, _, _ in
                dayBuilds += 1
                return Text(String(calendar.component(.day, from: date)))
            }.frame(width: 600)
        }.frame(width: 600, height: 400)
        let window = NSWindow(contentRect: CGRect(x: -2000, y: -2000, width: 600, height: 400),
                              styleMask: [.borderless], backing: .buffered, defer: false)
        window.isReleasedWhenClosed = false
        window.contentView = NSHostingView(rootView: content)
        window.orderFront(nil)
        defer { window.close() }
        // Let initial sizing and geometry callbacks settle before measuring scroll updates.
        try await Task.sleep(for: .milliseconds(500))
        func descendant(in view: NSView) -> NSScrollView? {
            if let scroll = view as? NSScrollView { return scroll }
            return view.subviews.lazy.compactMap { descendant(in: $0) }.first
        }
        let scroll = try #require(window.contentView.flatMap { descendant(in: $0) })
        let initial = dayBuilds
        #expect(initial > 0)
        for step in 1...10 {
            scroll.contentView.scroll(to: CGPoint(x: 0, y: step * 20))
            scroll.reflectScrolledClipView(scroll.contentView)
            try await Task.sleep(for: .milliseconds(20))
        }
        try await Task.sleep(for: .milliseconds(100))
        #expect(scroll.contentView.bounds.minY == 200)
        #expect(dayBuilds == initial)
    }
    #endif

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

}

@Suite("Calendar arithmetic and selection")
struct CalendarTests {
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

}

extension HostedRenderingTests {
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

    @MainActor @Test("Custom builders preserve selected dates, week mode and disabled selection")
    func customBuildersRetainSettings() throws {
        let calendar = gregorian()
        var renderedDays: [Date] = []
        var selectedDays: Set<Date> = []
        var enabledValues: [Bool] = []
        let owner = RangeOwner()
        let start = try date(2024, 2, 6, hour: 12, calendar: calendar)
        let end = try date(2024, 2, 8, hour: 16, calendar: calendar)
        owner.selection = start...end
        let view = CalendarView(date: .constant(try date(2024, 2, 10, calendar: calendar)),
                                selection: Binding(for: \RangeOwner.selection, on: owner),
                                calendar: calendar, type: .weekly)
            .selectionEnabled(false).multiselectionEnabled(false)
            .headerView { _, _ in Text("Custom header") }
            .weekdaysView { _ in Text("Custom weekdays") }
            .dayView { date, _, _, position in
                if position != nil { selectedDays.insert(date) }
                return DayProbe(date: date) { day, enabled in renderedDays.append(day); enabledValues.append(enabled) }
            }
        let image = ImageRenderer(content: view.frame(width: 350, height: 150)).cgImage
        #expect(image != nil)
        #expect(Set(renderedDays).count == 7)
        #expect(selectedDays == Set(try [6, 7, 8].map { try date(2024, 2, $0, calendar: calendar) }))
        #expect(owner.selection == start...end, "Styling must not rewrite the caller's dates or times")
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
