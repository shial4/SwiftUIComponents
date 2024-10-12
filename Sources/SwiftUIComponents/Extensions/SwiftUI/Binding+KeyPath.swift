import Foundation
import SwiftUI

public extension Binding where Value: Equatable {
    static func create<T: AnyObject>(for keyPath: ReferenceWritableKeyPath<T, Value>, on object: T) -> Binding<Value> {
        Binding(
            get: { object[keyPath: keyPath] },
            set: { newValue in object[keyPath: keyPath] = newValue }
        )
    }
#if !SKIP
    init<T: AnyObject>(for keyPath: ReferenceWritableKeyPath<T, Value>, on object: T) {
        self = Binding.create(for: keyPath, on: object)
    }
#endif
}
