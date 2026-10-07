#if os(macOS)
import AppKit
import Observation
import SwiftUI
import Testing
@testable import SwiftUIComponents

@MainActor @Suite("Mounted native scrolling", .serialized)
struct DynamicListIntegrationTests {
    @Test("Initial and external offsets scroll both axes with either sizing mode",
          arguments: [Orientation.horizontal, .vertical], [false, true])
    func boundOffsets(orientation: Orientation, automatic: Bool) async throws {
        let model = ListState(orientation: orientation, offset: -120)
        model.automatic = automatic
        let window = mount(model)
        defer { window.close() }
        let scrollView = try await findScrollView(in: window)
        try await eventually { abs(axisOffset(scrollView, orientation) - 120) < 1 }
        model.offset = -320
        try await eventually { abs(axisOffset(scrollView, orientation) - 320) < 1 && abs(model.offset + 320) < 1 }
        #expect(abs(model.offset + 320) < 1)
        withAnimation(.linear(duration: 0.15)) { model.offset = -600 }
        try await eventually { abs(axisOffset(scrollView, orientation) - 600) < 1 && abs(model.offset + 600) < 1 }
        #expect(abs(model.offset + 600) < 1)
    }

    @Test("Native user scrolling writes the binding; content shrink clamps it", arguments: [false, true])
    func nativeScrollAndShrink(automatic: Bool) async throws {
        let model = ListState(orientation: .vertical)
        model.automatic = automatic
        let window = mount(model)
        defer { window.close() }
        let scrollView = try await findScrollView(in: window)
        try await eventually { scrollView.documentView?.frame.height ?? 0 > 1000 }
        scrollView.contentView.scroll(to: CGPoint(x: 0, y: 240))
        scrollView.reflectScrolledClipView(scrollView.contentView)
        try await eventually { abs(model.offset + 240) < 1 }
        model.count = 1
        try await eventually { abs(model.offset) < 1 }
        #expect(abs(scrollView.contentView.bounds.minY) < 1)
    }

    @Test("Large lists render a small visible subset with either sizing mode", arguments: [false, true])
    func lazyCells(automatic: Bool) async throws {
        let model = ListState(orientation: .vertical)
        model.automatic = automatic
        model.count = 10_000
        let window = mount(model)
        defer { window.close() }
        _ = try await findScrollView(in: window)
        try await eventually { !model.appeared.isEmpty }
        #expect(model.appeared.count < 100)
        #expect(model.appeared.contains(0))
    }

    @Test("Empty and variable-sized content support clamping and updates")
    func variableAndEmpty() async throws {
        let model = ListState(orientation: .horizontal)
        model.lengths = [100, 150, 200, 250]
        let window = mount(model)
        defer { window.close() }
        let scrollView = try await findScrollView(in: window)
        try await eventually { scrollView.documentView?.frame.width ?? 0 >= 700 }
        model.offset = -1000
        try await eventually { abs(model.offset + 400) < 2 }
        model.lengths = []
        try await eventually { abs(model.offset) < 1 }
    }

    @Test("Viewport resizing and axis changes preserve the current position", arguments: [false, true])
    func resizingAndAxis(automatic: Bool) async throws {
        let model = ListState(orientation: .horizontal, offset: -200)
        model.automatic = automatic
        let window = mount(model)
        defer { window.close() }
        let scrollView = try await findScrollView(in: window)
        try await eventually { abs(axisOffset(scrollView, .horizontal) - 200) < 1 }
        model.width = 500
        window.setContentSize(CGSize(width: 500, height: 200))
        try await eventually { scrollView.contentView.bounds.width >= 500 && abs(model.offset + 200) < 1 }
        model.orientation = .vertical
        try await eventually { abs(axisOffset(scrollView, .vertical) - 200) < 1 && abs(model.offset + 200) < 1 }
        #expect(abs(model.offset + 200) < 1)
    }

    @Test("Content determines cell sizes and changing content updates the scroll bounds",
          arguments: [Orientation.horizontal, .vertical])
    func automaticContentSizing(orientation: Orientation) async throws {
        let model = ListState(orientation: orientation)
        model.automatic = true
        model.count = 3
        let window = mount(model)
        defer { window.close() }
        let scrollView = try await findScrollView(in: window)
        func contentLength() -> Double {
            model.sizes.values.reduce(0) { $0 + (orientation == .horizontal ? $1.width : $1.height) }
        }
        func documentLength() -> Double {
            guard let document = scrollView.documentView else { return 0 }
            return orientation == .horizontal ? document.frame.width : document.frame.height
        }
        let viewportLength = orientation == .horizontal ? model.width : 200
        try await eventually("Initial automatic sizing: sizes=\(model.sizes), document=\(documentLength()), content=\(contentLength())") {
            model.sizes.count == 3 && abs(documentLength() - max(viewportLength, contentLength())) < 2
        }
        #expect(Set(model.sizes.values.map { orientation == .horizontal ? $0.width : $0.height }).count == 3)
        let originalLength = contentLength()
        model.expanded = true
        try await eventually("Expanded content: document=\(documentLength()), content=\(contentLength()), original=\(originalLength)") {
            documentLength() > originalLength + 50
        }
        model.offset = -100_000
        try await eventually("Expanded end offset: offset=\(model.offset), document=\(documentLength()), content=\(contentLength())") {
            abs(model.offset + documentLength() - viewportLength) < 2
        }
        #expect(abs(axisOffset(scrollView, orientation) + model.offset) < 2)
        // A repeated end request must normalize the binding even when no scrolling occurs.
        model.offset = -200_000
        try await eventually { abs(model.offset + documentLength() - viewportLength) < 2 }
        model.expanded = false
        try await eventually("Shrunk content: offset=\(model.offset), document=\(documentLength()), content=\(contentLength()), original=\(originalLength)") {
            abs(contentLength() - originalLength) < 2 && abs(model.offset + max(0, originalLength - viewportLength)) < 2
        }
        model.count = 0
        try await eventually { abs(model.offset) < 1 && abs(axisOffset(scrollView, orientation)) < 1 }
    }

    @Test("Automatic empty and short lists clamp the initial offset",
          arguments: [Orientation.horizontal, .vertical], [-1, 0, 1])
    func automaticShortContent(orientation: Orientation, count: Int) async throws {
        let model = ListState(orientation: orientation, offset: -100_000)
        model.automatic = true
        model.count = count
        let window = mount(model)
        defer { window.close() }
        let scrollView = try await findScrollView(in: window)
        try await eventually { model.offset == 0 && abs(axisOffset(scrollView, orientation)) < 1 }
    }

    @Test("Automatic lists resolve an initial offset beyond their estimated end",
          arguments: [Orientation.horizontal, .vertical], [30, 10_000])
    func automaticInitialEnd(orientation: Orientation, count: Int) async throws {
        let model = ListState(orientation: orientation, offset: -100_000_000)
        model.automatic = true
        model.count = count
        let window = mount(model)
        defer { window.close() }
        let scrollView = try await findScrollView(in: window)
        try await eventually("Initial end: offset=\(model.offset), native=\(axisOffset(scrollView, orientation)), document=\(String(describing: scrollView.documentView?.frame)), viewport=\(scrollView.contentView.bounds), appeared=\(model.appeared)") {
            guard let document = scrollView.documentView else { return false }
            let extent = orientation == .horizontal ? document.frame.width : document.frame.height
            let viewport = orientation == .horizontal ? scrollView.contentView.bounds.width : scrollView.contentView.bounds.height
            return model.appeared.contains(model.count - 1)
                && model.visibleIndex == model.count - 1
                && abs(model.offset + extent - viewport) < 2
                && abs(axisOffset(scrollView, orientation) + model.offset) < 2
        }
    }

    @Test("Automatic sizing without an offset binding permits native scrolling")
    func automaticUnboundScrolling() async throws {
        let model = ListState(orientation: .vertical)
        model.automatic = true
        model.observesOffset = false
        let window = mount(model)
        defer { window.close() }
        let scrollView = try await findScrollView(in: window)
        try await eventually { scrollView.documentView?.frame.height ?? 0 > 1000 }
        scrollView.contentView.scroll(to: CGPoint(x: 0, y: 240))
        scrollView.reflectScrolledClipView(scrollView.contentView)
        try await eventually { abs(axisOffset(scrollView, .vertical) - 240) < 1 }
        #expect(model.offset == 0)
        model.count = 1
        try await eventually { abs(axisOffset(scrollView, .vertical)) < 1 }
    }

    @Test("Shared cell-ID scrolling supports initial positions, commands, resizing and removal",
          arguments: [Orientation.horizontal, .vertical], [false, true])
    func indexedScrolling(orientation: Orientation, automatic: Bool) async throws {
        let model = ListState(orientation: orientation)
        model.indexed = true
        model.index = 5
        model.automatic = automatic
        let window = mount(model)
        defer { window.close() }
        let scrollView = try await findScrollView(in: window)
        try await eventually("Initial index: \(String(describing: model.index)), visible: \(String(describing: model.visibleIndex)), offset: \(axisOffset(scrollView, orientation))") {
            axisOffset(scrollView, orientation) > 0 && model.visibleIndex == 5 && model.index == nil
        }
        model.index = 12
        try await eventually("Requested 12: index=\(String(describing: model.index)), offset=\(axisOffset(scrollView, orientation)), appeared=\(model.appeared)") { model.visibleIndex == 12 && model.index == nil && model.appeared.contains(12) }
        model.index = 0
        try await eventually("Requested start: index=\(String(describing: model.index)), visible=\(String(describing: model.visibleIndex)), offset=\(axisOffset(scrollView, orientation)), changes=\(model.visibleChanges)") { abs(axisOffset(scrollView, orientation)) < 1 && model.visibleIndex == 0 && model.index == nil }
        if automatic {
            model.expanded = true
            try await eventually { model.sizes.values.contains { $0.height > 80 } }
        }
        model.count = 0
        try await eventually("Empty indexed content: index=\(String(describing: model.index)), offset=\(axisOffset(scrollView, orientation))") { model.visibleIndex == nil && model.index == nil && abs(axisOffset(scrollView, orientation)) < 1 }
    }

    @Test("Visible-cell callbacks track initial and repopulated content without duplicates",
          arguments: [Orientation.horizontal, .vertical], [false, true])
    func distinctVisibleCells(orientation: Orientation, automatic: Bool) async throws {
        let model = ListState(orientation: orientation)
        model.indexed = true
        model.automatic = automatic
        let window = mount(model)
        defer { window.close() }
        _ = try await findScrollView(in: window)
        try await eventually { model.visibleIndex == 0 && model.index == nil }
        model.index = 0
        try await eventually { model.index == nil }
        model.count = 0
        try await eventually { model.visibleIndex == nil }
        // Let the native position binding finish reacting to removed cells.
        try await Task.sleep(for: .milliseconds(120))
        #expect(model.visibleChanges == [0, nil])
        model.count = 30
        try await eventually { model.visibleIndex == 0 }
        try await Task.sleep(for: .milliseconds(120))
        #expect(model.visibleChanges == [0, nil, 0])
    }

    private func mount(_ model: ListState) -> NSWindow {
        _ = NSApplication.shared
        let window = NSWindow(contentRect: CGRect(x: -2000, y: -2000, width: model.width, height: 200),
                              styleMask: [.borderless], backing: .buffered, defer: false)
        window.isReleasedWhenClosed = false
        window.contentView = NSHostingView(rootView: ListHarness(model: model))
        window.orderFront(nil)
        return window
    }

    private func axisOffset(_ view: NSScrollView, _ orientation: Orientation) -> Double {
        orientation == .horizontal ? view.contentView.bounds.minX : view.contentView.bounds.minY
    }

    private func findScrollView(in window: NSWindow) async throws -> NSScrollView {
        var found: NSScrollView?
        try await eventually {
            window.contentView?.layoutSubtreeIfNeeded()
            found = window.contentView.flatMap { descendant(in: $0) }
            return found != nil
        }
        return try #require(found)
    }

    private func descendant(in view: NSView) -> NSScrollView? {
        if let scroll = view as? NSScrollView { return scroll }
        return view.subviews.lazy.compactMap { descendant(in: $0) }.first
    }

    private func eventually(_ message: @autoclosure () -> String = "Native scrolling did not reach the expected state",
                            _ condition: () -> Bool) async throws {
        let deadline = ContinuousClock.now.advanced(by: .seconds(3))
        while !condition(), ContinuousClock.now < deadline { try await Task.sleep(for: .milliseconds(20)) }
        try #require(condition(), "\(message())")
    }
}

@MainActor @Observable private final class ListState {
    var orientation: Orientation
    var offset: Double
    var indexed = false
    var index: Int?
    var visibleIndex: Int?
    var width = 300.0
    var count = 30
    var lengths: [Double]?
    var automatic = false
    var observesOffset = true
    var expanded = false
    @ObservationIgnored var appeared: Set<Int> = []
    @ObservationIgnored var sizes: [Int: CGSize] = [:]
    @ObservationIgnored var visibleChanges: [Int?] = []
    func recordVisibleCell(_ index: Int?) {
        visibleChanges.append(index)
        visibleIndex = index
    }
    init(orientation: Orientation, offset: Double = 0) {
        self.orientation = orientation
        self.offset = offset
    }
}

private struct ListHarness: View {
    @Bindable var model: ListState
    var body: some View {
        Group {
            if model.indexed {
                if model.automatic {
                    DynamicList(scrollToIndex: $model.index, orientation: model.orientation,
                                numberOfItems: model.count) { automaticCell($0) }
                        .onVisibleCellChange(model.recordVisibleCell)
                } else {
                    DynamicList(scrollToIndex: $model.index, orientation: model.orientation,
                                numberOfItems: model.count, itemLength: 40) { cell($0) }
                        .onVisibleCellChange(model.recordVisibleCell)
                }
            } else if model.automatic {
                if model.observesOffset {
                    DynamicList(scrollOffset: $model.offset, orientation: model.orientation,
                                numberOfItems: model.count) { automaticCell($0) }
                        .onVisibleCellChange(model.recordVisibleCell)
                } else {
                    DynamicList(orientation: model.orientation, numberOfItems: model.count) { automaticCell($0) }
                }
            } else if let lengths = model.lengths {
                DynamicList(scrollOffset: $model.offset, orientation: model.orientation, itemLengths: lengths) { cell($0) }
            } else {
                DynamicList(scrollOffset: $model.offset, orientation: model.orientation,
                            numberOfItems: model.count, itemLength: 40) { cell($0) }
            }
        }
        .frame(width: model.width, height: 200)
    }
    private func cell(_ index: Int) -> some View {
        Text("Cell \(index)").frame(maxWidth: .infinity, maxHeight: .infinity)
            .onAppear { model.appeared.insert(index) }
    }
    private func automaticCell(_ index: Int) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Cell \(index)" + String(repeating: " details", count: index % 3 + (model.expanded ? 3 : 0)))
            ForEach(0..<(index % 3 + (model.expanded ? 2 : 0)), id: \.self) { line in
                Text("Detail \(line)")
            }
        }
        .font(.system(size: 16))
        .padding(12)
        .onGeometryChange(for: CGSize.self) { $0.size } action: { model.sizes[index] = $0 }
        .onAppear { model.appeared.insert(index) }
    }
}
#endif
