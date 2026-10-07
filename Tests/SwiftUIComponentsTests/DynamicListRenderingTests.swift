#if os(macOS) || os(iOS)
#if os(macOS)
import AppKit
#else
import UIKit
#endif
import Observation
import SwiftUI
import Testing
@testable import SwiftUIComponents

extension HostedRenderingTests {
    @Test("Large lists defer cell builders during initial layout and distant jumps",
          arguments: [Orientation.horizontal, .vertical], ListRenderingSizing.allCases)
    func boundedConstruction(orientation: Orientation, sizing: ListRenderingSizing) async throws {
        let model = ListRenderingProbe()
        let content = ListRenderingHarness(model: model, orientation: orientation, sizing: sizing)
            .frame(width: 300, height: 200)
            .ignoresSafeArea()
            // Layout/build-count checks use offscreen windows, which cannot reliably drive
            // native scroll animations. Catalogue UI checks cover animated arrival.
            .transaction { $0.disablesAnimations = true }
        #if os(macOS)
        _ = NSApplication.shared
        let window = NSWindow(contentRect: CGRect(x: -2000, y: -2000, width: 300, height: 200),
                              styleMask: [.borderless], backing: .buffered, defer: false)
        window.isReleasedWhenClosed = false
        window.contentView = NSHostingView(rootView: content)
        window.orderFront(nil)
        defer { window.close() }
        #else
        let controller = UIHostingController(rootView: content)
        let window = UIWindow(frame: CGRect(x: 0, y: 0, width: 300, height: 200))
        window.rootViewController = controller
        window.makeKeyAndVisible()
        defer { window.isHidden = true }
        #endif

        // Count builder calls, not just onAppear: identity lookup can otherwise
        // construct every cell while only reporting a handful as visible.
        for (step, index) in [0, 9_999, 5_000, 5_010, 0, 9_999, 9_999, 3, 8_000, 120, 6_500].enumerated() {
            if step > 0 {
                model.builds = [:]
                if step.isMultiple(of: 2) {
                    withAnimation(.linear(duration: 0.15)) { model.index = index }
                } else {
                    model.index = index
                }
            }
            let deadline = ContinuousClock.now.advanced(by: .seconds(5))
            var visibleSince: ContinuousClock.Instant?
            var settled = false
            while ContinuousClock.now < deadline {
                let now = ContinuousClock.now
                if model.visible.contains(index), model.index == nil {
                    if visibleSince == nil { visibleSince = now }
                    if let visibleSince, now - visibleSince >= .milliseconds(200) {
                        settled = true
                        break
                    }
                } else {
                    visibleSince = nil
                }
                try await Task.sleep(for: .milliseconds(20))
            }
            // Lower construction counts must not hide an inaccurate scroll target.
            try #require(settled, "Step \(step): cell \(index) did not stay visible after the jump: \(model.visible)")
            #expect(model.builds.count < 100, "Target \(index) constructed \(model.builds.count) cells")
            #expect(model.builds.values.reduce(0, +) < 500)
            #expect(model.index == nil)
            let reportedIndex = try #require(model.reportedIndex)
            #expect((0..<model.count).contains(reportedIndex))
        }
        #expect(!model.reportedChanges.contains(nil), "A jump must not temporarily report an empty list")
        #expect(zip(model.reportedChanges, model.reportedChanges.dropFirst()).allSatisfy { $0 != $1 },
                "Visible-cell callbacks must not repeat an unchanged index")

        // A data change and a newer request must replace any pending correction.
        model.index = 9_999
        try await Task.sleep(for: .milliseconds(20))
        model.count = 5
        model.index = 3
        try await reaches(3, model: model)
        try await Task.sleep(for: .milliseconds(600))
        #expect(model.visible.contains(3), "An old jump must not override the newer request")
        model.count = 0
        model.index = 9_999
        try await Task.sleep(for: .milliseconds(150))
        #expect(model.index == nil)
        #expect(model.visible.isEmpty)
        #expect(model.reportedIndex == nil)
        model.count = 10
        model.index = 8
        try await reaches(8, model: model)
    }

    private func reaches(_ index: Int, model: ListRenderingProbe) async throws {
        let deadline = ContinuousClock.now.advanced(by: .seconds(3))
        while !model.visible.contains(index), ContinuousClock.now < deadline {
            try await Task.sleep(for: .milliseconds(20))
        }
        try #require(model.visible.contains(index), "Cell \(index) did not become visible: \(model.visible)")
    }
}

enum ListRenderingSizing: CaseIterable { case automatic, uniform, variable }

@MainActor @Observable private final class ListRenderingProbe {
    var index: Int?
    var count = 10_000
    @ObservationIgnored var builds: [Int: Int] = [:]
    @ObservationIgnored var visible: Set<Int> = []
    @ObservationIgnored var reportedIndex: Int?
    @ObservationIgnored var reportedChanges: [Int?] = []

    func recordVisibleIndex(_ index: Int?) {
        reportedIndex = index
        reportedChanges.append(index)
    }
}

private struct ListRenderingHarness: View {
    @Bindable var model: ListRenderingProbe
    let orientation: Orientation
    let sizing: ListRenderingSizing

    var body: some View {
        switch sizing {
        case .automatic:
            DynamicList(scrollToIndex: $model.index, orientation: orientation,
                        numberOfItems: model.count) { cell($0) }
                .onVisibleCellChange(model.recordVisibleIndex)
        case .uniform:
            DynamicList(scrollToIndex: $model.index, orientation: orientation,
                        numberOfItems: model.count, itemLength: 80) { cell($0) }
                .onVisibleCellChange(model.recordVisibleIndex)
        case .variable:
            DynamicList(scrollToIndex: $model.index, orientation: orientation,
                        itemLengths: (0..<model.count).map { 70 + Double($0 % 3) * 20 }) { cell($0) }
                .onVisibleCellChange(model.recordVisibleIndex)
        }
    }

    private func cell(_ index: Int) -> some View {
        model.builds[index, default: 0] += 1
        return VStack {
            Text("Cell \(index)")
            ForEach(0..<(index % 3), id: \.self) { detail in Text("Detail \(detail)") }
        }
        .padding(12)
        .onDisappear { model.visible.remove(index) }
        .onScrollVisibilityChange(threshold: 0.1) { visible in
            if visible { model.visible.insert(index) } else { model.visible.remove(index) }
        }
    }
}
#endif
