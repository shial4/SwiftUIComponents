import SwiftUI
#if os(Android)
import SkipBridge
#endif

extension View {
    /// Skip's focused modifier requests focus but does not clear it when set to false.
    func componentDismissKeyboard() {
        #if os(Android)
        guard let activity = UIApplication.shared.dynamicAndroidActivity(),
              let field: AnyDynamicObject = try? activity.getCurrentFocus() else { return }
        let keyboard: AnyDynamicObject? = try? activity.getSystemService("input_method")
        let token: AnyDynamicObject? = try? field.getWindowToken()
        let _: Bool? = try? keyboard?.hideSoftInputFromWindow(token, 0)
        let _: Void? = try? field.clearFocus()
        #endif
    }

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
