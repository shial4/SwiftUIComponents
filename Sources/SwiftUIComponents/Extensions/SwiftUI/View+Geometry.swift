import SwiftUI

struct SizePreferenceKey: PreferenceKey {
    static var defaultValue: CGSize = .zero
    
    static func reduce(value: inout CGSize, nextValue: () -> CGSize) {
        value = nextValue()
    }
}

struct FramePreferenceKey: PreferenceKey {
    static var defaultValue: CGRect = .zero
    
    static func reduce(value: inout CGRect, nextValue: () -> CGRect) {
        value = nextValue()
    }
}

extension View {
    func size(onChange: @escaping (CGSize) -> Void) -> some View {
        background(
            GeometryReader { proxy in
                Color.clear
                    .preference(key: SizePreferenceKey.self, value: proxy.size)
            }
        )
        .onPreferenceChange(SizePreferenceKey.self, perform: onChange)
    }
    
    func size(onChange size: Binding<CGSize>) -> some View {
        background(
            GeometryReader { proxy in
                Color.clear
                    .preference(key: SizePreferenceKey.self, value: proxy.size)
            }
        )
        .onPreferenceChange(SizePreferenceKey.self, perform: { value in
            size.wrappedValue = value
        })
    }
    
    func frame(onChange: @escaping (CGRect) -> Void) -> some View {
        background(
            GeometryReader { proxy in
                Color.clear
                    .preference(key: FramePreferenceKey.self, value: proxy.frame(in: CoordinateSpace.global))
            }
        )
        .onPreferenceChange(FramePreferenceKey.self, perform: onChange)
    }
    
    func frame(onChange frame: Binding<CGRect>) -> some View {
        background(
            GeometryReader { proxy in
                Color.clear
                    .preference(key: FramePreferenceKey.self, value: proxy.frame(in: CoordinateSpace.global))
            }
        )
        .onPreferenceChange(FramePreferenceKey.self, perform: { value in
            frame.wrappedValue = value
        })
    }
}
