import Testing

// Hosted views share the application run loop. Run them one at a time so
// another suite cannot consume a scroll test's deadline with synchronous layout.
@MainActor @Suite("Hosted SwiftUI rendering", .serialized)
struct HostedRenderingTests {}
