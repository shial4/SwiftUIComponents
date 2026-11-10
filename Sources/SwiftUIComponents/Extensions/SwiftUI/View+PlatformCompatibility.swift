import SwiftUI
#if os(Android)
import SkipBridge
#endif

extension View {
    /// Explicit dismissal also supports Skip versions that only request focus.
    func componentDismissKeyboard() {
        #if os(Android)
        try? jniContext {
            guard let activity = UIApplication.shared.dynamicAndroidActivity()?.toJavaObject(options: []) else { return }
            // Dynamic calls reflect over the entire Activity/View hierarchy and can
            // block the first dismissal. These Android methods have stable signatures.
            let activityClass = try JClass(name: "android/app/Activity", systemClass: true)
            let viewClass = try JClass(name: "android/view/View", systemClass: true)
            let keyboardClass = try JClass(name: "android/view/inputmethod/InputMethodManager", systemClass: true)
            guard let getFocus = activityClass.getMethodID(name: "getCurrentFocus", sig: "()Landroid/view/View;"),
                  let getService = activityClass.getMethodID(name: "getSystemService", sig: "(Ljava/lang/String;)Ljava/lang/Object;"),
                  let getToken = viewClass.getMethodID(name: "getWindowToken", sig: "()Landroid/os/IBinder;"),
                  let clearFocus = viewClass.getMethodID(name: "clearFocus", sig: "()V"),
                  let hideKeyboard = keyboardClass.getMethodID(name: "hideSoftInputFromWindow", sig: "(Landroid/os/IBinder;I)Z"),
                  let field = try activity.call(method: getFocus, options: [], args: []) as JavaObjectPointer? else { return }
            defer { let _: Void? = try? field.call(method: clearFocus, options: [], args: []) }
            guard let keyboard = try activity.call(method: getService, options: [], args: ["input_method".toJavaParameter(options: [])]) as JavaObjectPointer?,
                  let token = try field.call(method: getToken, options: [], args: []) as JavaObjectPointer? else { return }
            let _: Bool = try keyboard.call(method: hideKeyboard, options: [], args: [token.toJavaParameter(options: []), Int32(0).toJavaParameter(options: [])])
        }
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
