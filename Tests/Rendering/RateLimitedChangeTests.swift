#if os(macOS)
import AppKit
import Observation
import SwiftUI
import Testing
import SwiftUIComponents

extension HostedRenderingTests {
    @Test("Debounce replaces pending changes and waits for a full quiet interval")
    func rateLimitedDebounce() async throws {
        let host = ChangeHost(mode: .debounce)
        defer { host.close() }
        try await host.ready()

        try await host.change(to: 1)
        try await Task.sleep(for: .milliseconds(100))
        try await host.change(to: 2)
        #expect(host.state.events.isEmpty)
        try await host.wait { host.state.events.count == 1 }

        #expect(host.state.events.map(\.value) == [2])
        let observed = try #require(host.state.observed[2])
        #expect(observed.duration(to: host.state.events[0].time) >= host.state.interval)

        // Returning to the initial value is still a new change.
        try await host.change(to: 0)
        try await host.wait { host.state.events.count == 2 }
        #expect(host.state.events.map(\.value) == [2, 0])
    }

    @Test("Throttle delivers the first and latest changes without postponing its window")
    func rateLimitedThrottleLatest() async throws {
        let host = ChangeHost(mode: .throttleLatest)
        defer { host.close() }
        try await host.ready()

        try await host.change(to: 1)
        try #require(host.state.events.map(\.value) == [1])
        let first = host.state.events[0].time
        try await host.change(to: 2)
        // Keep changing past the first deadline: throttle must not behave like debounce.
        var value = 2
        while host.state.events.count == 1 && ContinuousClock.now < first + .seconds(2) {
            try await Task.sleep(for: .milliseconds(40))
            value += 1
            try await host.change(to: value)
        }
        try #require(host.state.events.count == 2)
        let second = host.state.events[1]
        #expect(second.value >= 2)
        #expect(first.duration(to: second.time) >= host.state.interval)
        let mostRecent = host.state.observed.filter { $0.value <= second.time }.keys.max()
        #expect(second.value == mostRecent)

        try await host.change(to: 100)
        #expect(host.state.events.count == 2, "A trailing delivery starts a new throttle interval")
        try await host.wait { host.state.events.count == 3 }
        #expect(host.state.events.map(\.value) == [1, second.value, 100])
        #expect(second.time.duration(to: host.state.events[2].time) >= host.state.interval)
    }

    @Test("Throttle can discard changes inside the interval and resume after idle")
    func rateLimitedThrottleFirst() async throws {
        let host = ChangeHost(mode: .throttleFirst)
        defer { host.close() }
        try await host.ready()

        try await host.change(to: 1)
        try await host.change(to: 2)
        try await host.change(to: 3)
        try await Task.sleep(for: host.state.interval + .milliseconds(50))
        #expect(host.state.events.map(\.value) == [1])

        try await host.change(to: 4)
        #expect(host.state.events.map(\.value) == [1, 4])
    }

    @Test("Initial values, equal values and unrelated renders do not trigger actions",
          arguments: ChangeMode.allCases)
    func rateLimitedIgnoresUnchangedValues(mode: ChangeMode) async throws {
        let host = ChangeHost(mode: mode, interval: .milliseconds(30))
        defer { host.close() }
        try await host.ready()

        host.state.value = 0
        host.state.revision += 1
        try await host.wait { host.state.renderedRevision == 1 }
        try await Task.sleep(for: .milliseconds(80))

        #expect(host.state.events.isEmpty)
    }

    @Test("Disappearing cancels pending work and reappearing starts fresh",
          arguments: [ChangeMode.debounce, .throttleLatest])
    func rateLimitedDisappearance(mode: ChangeMode) async throws {
        let host = ChangeHost(mode: mode)
        defer { host.close() }
        try await host.ready()
        try await host.change(to: 1)
        try await host.change(to: 2)
        let expected = mode == .debounce ? [] : [1]

        host.state.visible = false
        try await host.wait { !host.state.mounted }
        host.state.visible = true
        try await host.ready()
        // Remount before the old deadline; its canceled task must not fire or
        // overwrite the new lifetime's state.
        try await host.change(to: 3)
        if mode == .throttleLatest {
            #expect(host.state.events.map(\.value) == expected + [3])
        }
        try await Task.sleep(for: host.state.interval + .milliseconds(80))
        #expect(host.state.events.map(\.value) == expected + [3])
    }

    @Test("Nonpositive intervals deliver every observed change immediately",
          arguments: ChangeMode.allCases, [Duration.zero, .milliseconds(-10)])
    func rateLimitedNonpositiveIntervals(mode: ChangeMode, interval: Duration) async throws {
        let host = ChangeHost(mode: mode, interval: interval)
        defer { host.close() }
        try await host.ready()

        try await host.change(to: 1)
        #expect(host.state.events.map(\.value) == [1])
        try await host.change(to: 2)
        #expect(host.state.events.map(\.value) == [1, 2])
    }

    @Test("Separate views keep independent pending actions", arguments: [ChangeMode.debounce, .throttleLatest])
    func rateLimitedIndependentViews(mode: ChangeMode) async throws {
        let first = ChangeHost(mode: mode)
        let second = ChangeHost(mode: mode)
        defer { first.close(); second.close() }
        try await first.ready()
        try await second.ready()

        try await first.change(to: 1)
        try await second.change(to: 10)
        try await first.change(to: 2)
        try await second.change(to: 20)
        first.state.visible = false
        try await first.wait { !first.state.mounted }
        try await second.wait { second.state.events.last?.value == 20 }

        #expect(first.state.events.map(\.value) == (mode == .debounce ? [] : [1]))
        #expect(second.state.events.map(\.value) == (mode == .debounce ? [20] : [10, 20]))
    }
}

enum ChangeMode: CaseIterable, Sendable {
    case debounce, throttleLatest, throttleFirst
}

@MainActor @Observable private final class ChangeState {
    var value = 0
    var revision = 0
    var visible = true
    let interval: Duration
    var mounted = false
    var renderedRevision = 0
    var observed: [Int: ContinuousClock.Instant] = [:]
    var events: [(value: Int, time: ContinuousClock.Instant)] = []

    init(interval: Duration) { self.interval = interval }

    func record(_ value: Int) {
        MainActor.assertIsolated()
        events.append((value, .now))
    }
}

private struct ChangeTestView: View {
    let state: ChangeState
    let mode: ChangeMode

    var body: some View {
        VStack {
            if state.visible {
                observedView
                    .onAppear { state.mounted = true }
                    .onDisappear { state.mounted = false }
            }
        }
    }

    @ViewBuilder private var observedView: some View {
        let value = state.value
        let content = Text("\(value):\(state.revision)")
            .onChange(of: value) { state.observed[value] = .now }
            .onChange(of: state.revision) { state.renderedRevision = state.revision }
        switch mode {
        case .debounce:
            content.onChangeDebounced(of: value, interval: state.interval) { state.record(value) }
        case .throttleLatest, .throttleFirst:
            content.onChangeThrottled(of: value, interval: state.interval, latest: mode == .throttleLatest) {
                state.record(value)
            }
        }
    }
}

@MainActor private final class ChangeHost {
    let state: ChangeState
    private let window: NSWindow

    init(mode: ChangeMode, interval: Duration = .milliseconds(300)) {
        state = ChangeState(interval: interval)
        _ = NSApplication.shared
        window = NSWindow(contentRect: NSRect(x: 0, y: 0, width: 200, height: 100),
                          styleMask: [.borderless], backing: .buffered, defer: false)
        window.isReleasedWhenClosed = false
        window.contentView = NSHostingView(rootView: ChangeTestView(state: state, mode: mode))
        window.orderFront(nil)
    }

    func ready() async throws { try await wait { self.state.mounted } }

    func change(to value: Int) async throws {
        state.value = value
        try await wait { self.state.observed[value] != nil }
    }

    func wait(_ condition: () -> Bool) async throws {
        let deadline = ContinuousClock.now + .seconds(3)
        while !condition() && ContinuousClock.now < deadline {
            window.contentView?.layoutSubtreeIfNeeded()
            try await Task.sleep(for: .milliseconds(5))
        }
        try #require(condition(), "The hosted change modifier did not reach the expected state")
    }

    func close() { window.close() }
}
#endif
