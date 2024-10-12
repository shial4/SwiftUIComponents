#if SKIP
import SwiftUI

public extension View {
    func contentShape<S>(
        _ shape: S,
        eoFill: Bool = false
    ) -> some View where S : Shape {
        return self
    }
    
    func mask<Mask: View>(
        alignment: Alignment = .center,
        @ViewBuilder _ mask: () -> Mask
    ) -> some View {
        return self
    }
}
#endif
