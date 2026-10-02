import SwiftUI

extension View {
    /// Skip uses the background's layout bounds for gesture hit testing.
    func componentHitArea<S: Shape>(_ shape: S) -> some View {
        #if os(Android)
        background(shape.fill(Color.clear))
        #else
        contentShape(shape)
        #endif
    }

    /// Android exposes individual controls through Compose semantics.
    func componentAccessibilityChildren(_ behavior: AccessibilityChildBehavior) -> some View {
        #if os(Android)
        self
        #else
        accessibilityElement(children: behavior)
        #endif
    }
}

extension AccessibilityTraits {
    static var componentEmpty: Self {
        #if os(Android)
        // Skip's zero-argument initializer recursively constructs an empty literal.
        Self(rawValue: 0)
        #else
        []
        #endif
    }
}
