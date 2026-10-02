import SwiftUI

// SKIP @bridge
public struct ComponentCatalogRootView: View {
    // SKIP @bridge
    public init() {}

    public var body: some View { ContentView() }
}

/// Lifecycle entry points used by the Skip-generated Android app shell.
// SKIP @bridge
public final class ComponentCatalogAppDelegate: Sendable {
    // SKIP @bridge
    public static let shared = ComponentCatalogAppDelegate()
    private init() {}

    // SKIP @bridge
    public func onInit() {}
    // SKIP @bridge
    public func onLaunch() {}
    // SKIP @bridge
    public func onResume() {}
    // SKIP @bridge
    public func onPause() {}
    // SKIP @bridge
    public func onStop() {}
    // SKIP @bridge
    public func onDestroy() {}
    // SKIP @bridge
    public func onLowMemory() {}
}
