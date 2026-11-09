import Foundation
import SwiftUI
import Testing
@testable import SwiftUIComponents
#if os(macOS)
import AppKit
#endif

extension HostedRenderingTests {
    #if os(macOS)
    @Test("Calendar sizing keeps each day mounted instead of replacing its view tree")
    func sizingPreservesDays() async throws {
        _ = NSApplication.shared
        let calendar = gregorian()
        let preview = try date(2026, 10, 1, calendar: calendar)
        var appearances: [Date: Int] = [:]
        let content = CalendarContentView(selection: .constant(nil as TimeRange?),
                                          previewDate: preview, calendar: calendar) { day, _, _, _ in
            Text(String(calendar.component(.day, from: day)))
                .onAppear { appearances[day, default: 0] += 1 }
        }
        let window = NSWindow(contentRect: CGRect(x: -2000, y: -2000, width: 350, height: 350),
                              styleMask: [.borderless], backing: .buffered, defer: false)
        window.isReleasedWhenClosed = false
        window.contentView = NSHostingView(rootView: content)
        window.orderFront(nil)
        defer { window.close() }
        try await Task.sleep(for: .milliseconds(300))
        window.setContentSize(CGSize(width: 490, height: 490))
        try await Task.sleep(for: .milliseconds(300))
        let days = CalendarGrid(calendar: calendar).month(containing: preview)
        #expect(Set(appearances.keys) == Set(days))
        #expect(appearances.values.allSatisfy { $0 == 1 }, "Sizing must preserve day identity: \(appearances)")
    }

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

extension HostedRenderingTests {
    @MainActor @Test("CalendarView renders with a native ClosedRange binding")
    func nativeRangeRendering() throws {
        let calendar = gregorian()
        let first = try date(2024, 2, 10, calendar: calendar)
        let owner = RangeOwner()
        let binding = Binding(for: \RangeOwner.selection, on: owner)
        let view = CalendarView(date: .constant(first), selection: binding, calendar: calendar)
        #expect(ImageRenderer(content: view.frame(width: 350, height: 350)).cgImage != nil)
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
