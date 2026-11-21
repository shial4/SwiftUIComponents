import SwiftUI

/// Runs an action at most once per interval while the observed value changes.
@MainActor public struct ThrottleViewModifier<Value: Equatable>: ViewModifier {
    private let value: Value
    private let interval: Duration
    private let latest: Bool
    private let action: @MainActor () -> Void
    // Skip's generated state bridge requires internal visibility.
    @State var lastExecution: ContinuousClock.Instant?
    @State var pendingTask: Task<Void, Never>?

    public init(value: Value, interval: Duration, latest: Bool = true,
                action: @escaping @MainActor () -> Void) {
        self.value = value
        self.interval = interval
        self.latest = latest
        self.action = action
    }

    public func body(content: Content) -> some View {
        content
            .onChange(of: value) { schedule() }
            .onDisappear {
                cancel()
                lastExecution = nil
            }
    }

    private func schedule() {
        let now = ContinuousClock.now
        guard interval > .zero, let lastExecution,
              now < lastExecution.advanced(by: interval) else {
            cancel()
            execute()
            return
        }

        cancel()
        guard latest else { return }
        // New changes replace the pending action without moving its deadline.
        let deadline = lastExecution.advanced(by: interval)
        pendingTask = Task { @MainActor in
            do {
                try await ContinuousClock().sleep(until: deadline)
                try Task.checkCancellation()
            } catch {
                return
            }
            pendingTask = nil
            execute()
        }
    }

    private func execute() {
        lastExecution = ContinuousClock.now
        action()
    }

    private func cancel() {
        pendingTask?.cancel()
        pendingTask = nil
    }
}

public extension View {
    /// Runs `action` on the main actor at most once per `interval`.
    ///
    /// The initial value does not trigger the action. The first change runs
    /// immediately. With `latest: true`, changes within the interval replace
    /// the pending action, which runs when that interval ends. With `false`,
    /// those changes are discarded. Disappearing cancels pending work and resets
    /// the interval. A nonpositive interval runs every observed change immediately.
    /// Interval and policy changes apply to the next value change.
    ///
    /// ```swift
    /// Slider(value: $progress)
    ///     .onChangeThrottled(of: progress, interval: .milliseconds(300)) {
    ///         updatePreview(progress)
    ///     }
    /// ```
    @MainActor func onChangeThrottled<Value: Equatable>(
        of value: Value,
        interval: Duration = .milliseconds(250),
        latest: Bool = true,
        perform action: @escaping @MainActor () -> Void
    ) -> some View {
        modifier(ThrottleViewModifier(value: value, interval: interval, latest: latest, action: action))
    }
}
