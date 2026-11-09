#if !os(Android)
import Foundation
import Observation
import SwiftUI
import Testing
#if os(macOS)
import AppKit
#endif
@testable import SwiftUIComponents

private struct BindingTransactionKey: TransactionKey {
    static let defaultValue = 0
}

@Suite("Binding transactions")
struct BindingTransactionTests {
    @MainActor @Test("Search input forwards transactions and rejects commits from a cleared editor")
    func searchInputTransaction() throws {
        var text = ""
        var received: [Transaction] = []
        var editorID = UUID()
        let source = Binding(get: { text }, set: { value, transaction in
            text = value
            received.append(transaction)
        })
        func editor() -> Binding<String> {
            let id = editorID
            return SearchBar.inputBinding(source, isCurrent: { editorID == id })
        }
        var transaction = Transaction(animation: .linear(duration: 0.6))
        transaction.disablesAnimations = true
        transaction[BindingTransactionKey.self] = 42
        let original = editor()
        original.transaction(transaction).wrappedValue = "query"
        #expect(text == "query")
        let forwarded = try #require(received.first)
        #expect(forwarded.animation == transaction.animation)
        #expect(forwarded.disablesAnimations)
        #expect(forwarded[BindingTransactionKey.self] == 42)

        editorID = UUID()
        text = ""
        original.transaction(transaction).wrappedValue = "late keyboard commit"
        #expect(text.isEmpty && received.count == 1)
        let current = editor()
        current.transaction(transaction).wrappedValue = "fresh query"
        #expect(text == "fresh query" && received.count == 2)
        // Programmatic updates remain visible to the currently mounted field.
        text = "external update"
        #expect(current.wrappedValue == text)
    }

    @MainActor @Test("Calendar range conversion forwards the complete transaction", arguments: [0, 1, 2])
    func calendarTransaction(input: Int) throws {
        let start = Date(timeIntervalSince1970: 1_700_000_000)
        let end = start.addingTimeInterval(3600)
        var selection: ClosedRange<Date>? = start...end
        var received: Transaction?
        let source = Binding(get: { selection }, set: { value, transaction in
            selection = value
            received = transaction
        })
        var transaction = Transaction(animation: .linear(duration: 0.6))
        transaction.disablesAnimations = true
        transaction[BindingTransactionKey.self] = 42
        let range: TimeRange? = input == 0 ? TimeRange(start: start, end: end)
            : input == 1 ? nil : TimeRange(start: end, end: start)

        source.timeRange.transaction(transaction).wrappedValue = range

        #expect(selection == (input == 0 ? start...end : nil))
        let forwarded = try #require(received)
        #expect(forwarded.animation == transaction.animation)
        #expect(forwarded.disablesAnimations)
        #expect(forwarded[BindingTransactionKey.self] == 42)
    }
}

// Package tests on iOS have no application scene. Use the catalogue for iOS UI verification.
#if os(macOS)
extension HostedRenderingTests {
    @Test("Key-path bindings deliver the caller transaction to rendered views", arguments: [false, true], [0, 1, 2, 3])
    func keyPathTransaction(factory: Bool, mode: Int) async throws {
        let owner = TransactionBindingOwner()
        let probe = TransactionProbe()
        let host = TransactionHost(TextTransactionView(owner: owner, probe: probe))
        defer { host.close() }
        try await probe.wait(for: 0, layout: host.layout)
        let binding = factory ? Binding.create(for: \.value, on: owner) : Binding(for: \.value, on: owner)
        let transaction = testTransaction(mode: mode)

        if mode == 3 {
            withAnimation(transaction.animation) { binding.wrappedValue = 1 }
        } else {
            binding.transaction(transaction).wrappedValue = 1
        }

        let received = try await probe.wait(for: 1, layout: host.layout)
        expectTransaction(received, matches: transaction)
        binding.transaction(transaction).wrappedValue = 1
        #expect(owner.updates == 1, "An unchanged write must still avoid invalidating the owner")
    }

    @Test("Codable storage bindings preserve transactions when updating a mounted view", arguments: [0, 1, 2, 3])
    func storageTransaction(mode: Int) async throws {
        let name = "BindingTransactions.\(UUID())"
        let store = try #require(UserDefaults(suiteName: name))
        defer { store.removePersistentDomain(forName: name) }
        let probe = TransactionProbe()
        let host = TransactionHost(StorageTransactionView(store: store, probe: probe))
        defer { host.close() }
        try await probe.wait(for: 0, layout: host.layout)
        let binding = try #require(probe.binding)
        let transaction = testTransaction(mode: mode)

        if mode == 3 {
            withAnimation(transaction.animation) { binding.wrappedValue = 1 }
        } else {
            binding.transaction(transaction).wrappedValue = 1
        }

        let received = try await probe.wait(for: 1, layout: host.layout)
        expectTransaction(received, matches: transaction)
        #expect(store.codable(forKey: "value") as Int? == 1)
    }

    private func testTransaction(mode: Int) -> Transaction {
        var transaction = Transaction(animation: mode == 0 ? nil : .linear(duration: 0.6))
        transaction.disablesAnimations = mode == 2
        transaction[BindingTransactionKey.self] = mode == 3 ? 0 : 42
        return transaction
    }

    private func expectTransaction(_ received: Transaction, matches expected: Transaction) {
        #expect(received.animation == expected.animation)
        #expect(received.disablesAnimations == expected.disablesAnimations)
        #expect(received[BindingTransactionKey.self] == expected[BindingTransactionKey.self])
    }
}

@MainActor @Observable private final class TransactionBindingOwner {
    var value = 0 { didSet { updates += 1 } }
    var updates = 0
}

@MainActor private final class TransactionProbe {
    var values: [Int: Transaction] = [:]
    var binding: Binding<Int>?

    @discardableResult
    func wait(for value: Int, layout: () -> Void) async throws -> Transaction {
        let deadline = ContinuousClock.now + .seconds(3)
        while values[value] == nil && ContinuousClock.now < deadline {
            layout()
            try await Task.sleep(for: .milliseconds(10))
        }
        return try #require(values[value], "The hosted view did not render value \(value)")
    }
}

private struct TextTransactionView: View {
    let owner: TransactionBindingOwner
    let probe: TransactionProbe
    var body: some View {
        let value = owner.value
        Text("\(value)").transaction {
            // Later layout passes can carry an empty transaction. Capture the mutation's first pass.
            if probe.values[value] == nil { probe.values[value] = $0 }
        }
    }
}

private struct StorageTransactionView: View {
    @CodableAppStorage private var value: Int
    let probe: TransactionProbe
    init(store: UserDefaults, probe: TransactionProbe) {
        self._value = CodableAppStorage(wrappedValue: 0, "value", store: store)
        self.probe = probe
    }
    var body: some View {
        let current = value
        Text("\(current)")
            .transaction {
                if probe.values[current] == nil { probe.values[current] = $0 }
            }
            .onAppear { probe.binding = $value }
    }
}

@MainActor private final class TransactionHost {
    private let window: NSWindow
    init(_ view: some View) {
        _ = NSApplication.shared
        window = NSWindow(contentRect: NSRect(x: 0, y: 0, width: 320, height: 200),
                          styleMask: [.borderless], backing: .buffered, defer: false)
        window.isReleasedWhenClosed = false
        window.contentView = NSHostingView(rootView: view)
        window.orderFront(nil)
    }
    func layout() { window.contentView?.layoutSubtreeIfNeeded() }
    func close() { window.close() }
}
#endif
#endif
