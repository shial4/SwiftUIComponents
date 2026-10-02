import Foundation
import SwiftUI
import Testing
@testable import SwiftUIComponents

@Suite("Codable persistence")
struct StorageTests {
    @Test("JSON round trips, nil removes the key, corrupt data returns nil")
    func roundTrip() throws {
        let name = "SwiftUIComponentsTests.\(UUID())"
        let store = try #require(UserDefaults(suiteName: name))
        defer { store.removePersistentDomain(forName: name) }
        let value = ["count": 4]
        store.setCodable(value, forKey: "value")
        #expect(store.codable(forKey: "value") as [String: Int]? == value)
        store.setCodable(nil as [String: Int]?, forKey: "value")
        #expect(store.object(forKey: "value") == nil)
        store.set(Data("invalid JSON".utf8), forKey: "value")
        #expect(store.codable(forKey: "value") as [String: Int]? == nil)
    }

    @Test("An encoding failure preserves the existing stored value")
    func failedEncode() throws {
        let name = "SwiftUIComponentsTests.\(UUID())"
        let store = try #require(UserDefaults(suiteName: name))
        defer { store.removePersistentDomain(forName: name) }
        store.setCodable(7, forKey: "value")
        store.setCodable(Double.nan, forKey: "value")
        #expect(store.codable(forKey: "value") as Int? == 7)
    }

    @MainActor @Test("Wrappers share data and expose a writable binding")
    func wrappers() throws {
        let name = "SwiftUIComponentsTests.\(UUID())"
        let store = try #require(UserDefaults(suiteName: name))
        defer { store.removePersistentDomain(forName: name) }
        let first = CodableAppStorage(wrappedValue: [1, 2], "value", store: store)
        let second = CodableAppStorage(wrappedValue: [0], "value", store: store)
        #expect(first.wrappedValue == [1, 2])
        first.projectedValue.wrappedValue = [3, 4]
        #expect(first.wrappedValue == [3, 4])
        #expect(second.wrappedValue == [3, 4])
        #expect(store.codable(forKey: "value") as [Int]? == [3, 4])
    }

    @MainActor @Test("Missing or invalid stored data uses the supplied default")
    func defaults() throws {
        let name = "SwiftUIComponentsTests.\(UUID())"
        let store = try #require(UserDefaults(suiteName: name))
        defer { store.removePersistentDomain(forName: name) }
        store.set(Data("bad".utf8), forKey: "value")
        let wrapper = CodableAppStorage(wrappedValue: 8, "value", store: store)
        #expect(wrapper.wrappedValue == 8)
        wrapper.wrappedValue = 9
        #expect(wrapper.wrappedValue == 9)
    }
}
