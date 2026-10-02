#if os(Android)
import SwiftUI
import SkipUI
import SkipBridge

// Skip's automatic native bridge does not discover views nested in extensions.
// Materialize their shared SwiftUI bodies at this narrow boundary.
extension MuscleMap.Front: SkipUIBridging {
    nonisolated public var Java_view: any SkipUI.View {
        SkipBridge.assumeMainActorUnchecked { body.Java_viewOrEmpty }
    }
}

extension MuscleMap.Back: SkipUIBridging {
    nonisolated public var Java_view: any SkipUI.View {
        SkipBridge.assumeMainActorUnchecked { body.Java_viewOrEmpty }
    }
}
#endif
