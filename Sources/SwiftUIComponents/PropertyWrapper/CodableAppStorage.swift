import Foundation
import SwiftUI
#if os(Android)
import SkipAndroidBridge
public typealias CodableStorage = AndroidUserDefaults
#else
public typealias CodableStorage = Foundation.UserDefaults
#endif

/// JSON-backed AppStorage. Separate wrappers for the same key stay in sync.
/// Failed encodes preserve the previously stored value. The projected value is a binding.
@MainActor
@propertyWrapper
public struct CodableAppStorage<Value: Codable>: DynamicProperty {
    @AppStorage private var data: Data
    private let defaultValue: Value

    public init(wrappedValue defaultValue: Value, _ key: String, store: CodableStorage? = nil) {
        self.defaultValue = defaultValue
        self._data = AppStorage(wrappedValue: Data(), key, store: store)
        #if os(Android)
        // Skip does not discover AppStorage nested inside a custom property wrapper.
        // Activate its existing SharedPreferences observer and Compose state directly.
        self._data.projectedValue.appStorageBox?.Java_initStateSupport().trackState()
        #endif
    }

    public var wrappedValue: Value {
        get { (try? JSONDecoder().decode(Value.self, from: data)) ?? defaultValue }
        nonmutating set {
            guard let encoded = try? JSONEncoder().encode(newValue) else { return }
            if data != encoded { data = encoded }
        }
    }

    public var projectedValue: Binding<Value> {
        Binding(get: { wrappedValue }, set: { wrappedValue = $0 })
    }
}

public extension UserDefaults {
    /// Stores JSON data, removes the key for nil, and preserves data on encoding failure.
    func setCodable<T: Codable>(_ value: T?, forKey key: String) {
        guard let value else {
            removeObject(forKey: key)
            return
        }
        guard let encoded = try? JSONEncoder().encode(value) else { return }
        set(encoded, forKey: key)
    }

    func codable<T: Codable>(forKey key: String) -> T? {
        guard let data = data(forKey: key) else { return nil }
        return try? JSONDecoder().decode(T.self, from: data)
    }
}
