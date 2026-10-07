import SwiftUI

// Credits: https://www.fivestars.blog/articles/reverse-masks-how-to/
public extension View {
    @inlinable
    func reverseMask<Mask: View>(
        alignment: Alignment = .center,
        @ViewBuilder _ mask: () -> Mask
    ) -> some View {
        self.mask {
            Rectangle()
                .overlay(alignment: alignment) {
                    mask()
                        // Keep translated mask content inside the compositing layer.
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: alignment)
                        .blendMode(BlendMode.destinationOut)
                }
        }
    }
}
