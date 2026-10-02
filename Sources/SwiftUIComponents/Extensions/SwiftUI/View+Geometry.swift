import SwiftUI

// Retained for clients that use these public preference keys directly.
public struct SizePreferenceKey: PreferenceKey {
    public static let defaultValue: CGSize = .zero
    public static func reduce(value: inout CGSize, nextValue: () -> CGSize) { value = nextValue() }
}

public struct FramePreferenceKey: PreferenceKey {
    public static let defaultValue: CGRect = .zero
    public static func reduce(value: inout CGRect, nextValue: () -> CGRect) { value = nextValue() }
}

public extension View {
    func size(onChange: @escaping (CGSize) -> Void) -> some View {
        onGeometryChange(for: CGSize.self, of: \.size, action: onChange)
    }

    func size(onChange size: Binding<CGSize>) -> some View {
        self.size { size.wrappedValue = $0 }
    }

    func frame(onChange: @escaping (CGRect) -> Void) -> some View {
        onGeometryChange(for: CGRect.self, of: { $0.frame(in: .global) }, action: onChange)
    }

    func frame(onChange frame: Binding<CGRect>) -> some View {
        self.frame { frame.wrappedValue = $0 }
    }
}
