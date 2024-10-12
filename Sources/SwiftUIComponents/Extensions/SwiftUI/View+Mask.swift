import SwiftUI

// Credits: https://www.fivestars.blog/articles/reverse-masks-how-to/
public extension View {
    @inlinable
    func reverseMask<Mask: View>(
        alignment: Alignment = .center,
        @ViewBuilder _ mask: () -> Mask
    ) -> some View {
        self
#if !SKIP
            .mask {
                Rectangle()
                    .overlay(alignment: alignment) {
                        mask()
                            .blendMode(BlendMode.destinationOut)
                    }
            }
#endif
    }
}
