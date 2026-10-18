import Foundation
import SwiftUI

@MainActor
public extension Binding where Value: Equatable {
    static func create<T: AnyObject>(for keyPath: ReferenceWritableKeyPath<T, Value>, on object: T) -> Binding<Value> {
        Binding.preservingTransaction(
            get: { object[keyPath: keyPath] },
            set: { newValue in
                if object[keyPath: keyPath] != newValue { object[keyPath: keyPath] = newValue }
            }
        )
    }

    init<T: AnyObject>(for keyPath: ReferenceWritableKeyPath<T, Value>, on object: T) {
        self = Binding.create(for: keyPath, on: object)
    }
}

@MainActor
extension Binding {
    /// Preserve the caller's transaction when a computed binding writes to observable storage.
    static func preservingTransaction(
        get: @escaping @MainActor () -> Value,
        set: @escaping @MainActor (Value) -> Void
    ) -> Binding<Value> {
        #if os(Android)
        // SkipFuseUI 1.19 has no transaction-aware Binding setter or withTransaction.
        return Binding(get: get, set: set)
        #else
        return Binding(get: get, set: { value, transaction in
            withTransaction(transaction) { set(value) }
        })
        #endif
    }
}
