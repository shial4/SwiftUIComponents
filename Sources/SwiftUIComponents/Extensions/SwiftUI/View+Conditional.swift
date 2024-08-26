import SwiftUI

// Credits: https://www.avanderlee.com/swiftui/conditional-view-modifier/
extension View {
    /// Applies the given transform if the given condition evaluates to `true`.
    /// - Parameters:
    ///   - condition: The condition to evaluate.
    ///   - modifier: The `View` modifier to apply.
    /// - Returns: Either the original `View` or the modified `View` if the condition is `true`.
    @ViewBuilder func `if`<Content: View>(_ condition: @autoclosure () -> Bool, modifier: (Self) -> Content) -> some View {
        if condition() {
            modifier(self)
        } else {
            self
        }
    }

    /// Applies the given closure modifier.
    /// - Parameter closure: The `View` modifier to apply.
    /// - Returns:  The modified `View`
    func modified<Content: View>(@ViewBuilder _ closure: (Self) -> Content) -> some View {
        closure(self)
    }
}
