#if !SKIP
import SwiftUI

extension AnyTransition {
    /// Transition view from initial rect to final rect.
    /// - Parameters:
    ///   - from: Rect from which transition should start when inserting and finish when removing
    ///   - to: Rect to transition to when inserting and transition from when removing
    ///   - rotation: rotation
    ///   - scale: scale
    /// - Returns: constructed transition
    public static func transform(from: CGRect, to: CGRect, rotation: Angle = .zero, scale factor: Double = 1) -> AnyTransition {
        let scale = factor.isZero ? Double.leastNonzeroMagnitude : factor
        let homeAngle: Angle = rotation.degrees > 180 ? .degrees(360) : .zero
        let identity = FrameModifier(offset: .zero, rotation: homeAngle, scale: CGSize(width: 1, height: 1), anchor: .center)
        let active = FrameModifier(
            offset: CGSize(width: (from.midX - to.midX) / scale, height: (from.midY - to.midY) / scale),
            rotation: rotation,
            scale: CGSize(width: from.width / (to.width.isZero ? Double.leastNonzeroMagnitude : to.width),
                          height: from.height / (to.height.isZero ? Double.leastNonzeroMagnitude : to.height)),
            anchor: .center
        )
        return .modifier(active: active, identity: identity)
    }
}
#endif
