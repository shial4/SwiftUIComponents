import SwiftUI

/// Runs an action after the observed value stops changing for an interval.
@MainActor public struct DebounceViewModifier<Value: Equatable>: ViewModifier {
    private let value: Value
    private let interval: Duration
    private let action: @MainActor () -> Void
    // Skip's generated state bridge requires internal visibility.
    @State var pendingTask: Task<Void, Never>?

    public init(value: Value, interval: Duration, action: @escaping @MainActor () -> Void) {
        self.value = value
        self.interval = interval
        self.action = action
    }

    public func body(content: Content) -> some View {
        content
            .onChange(of: value) { schedule() }
            .onDisappear { cancel() }
    }

    private func schedule() {
        cancel()
        guard interval > .zero else {
            action()
            return
        }
        let deadline = ContinuousClock.now.advanced(by: interval)
        pendingTask = Task { @MainActor in
            do {
                try await ContinuousClock().sleep(until: deadline)
                try Task.checkCancellation()
            } catch {
                return
            }
            pendingTask = nil
            action()
        }
    }

    private func cancel() {
        pendingTask?.cancel()
        pendingTask = nil
    }
}

public extension View {
    /// Runs `action` on the main actor after `value` stops changing for `interval`.
    ///
    /// The initial value does not trigger the action. Each change replaces the
    /// pending action, and disappearing cancels it. A nonpositive interval runs
    /// the action immediately. Interval changes apply to the next value change.
    ///
    /// ```swift
    /// TextField("Search", text: $query)
    ///     .onChangeDebounced(of: query, interval: .milliseconds(300)) {
    ///         search(query)
    ///     }
    /// ```
    @MainActor func onChangeDebounced<Value: Equatable>(
        of value: Value,
        interval: Duration = .milliseconds(250),
        perform action: @escaping @MainActor () -> Void
    ) -> some View {
        modifier(DebounceViewModifier(value: value, interval: interval, action: action))
    }
}
