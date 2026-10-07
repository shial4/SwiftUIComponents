#if os(macOS)
import AppKit
import SwiftUI
import Testing
@testable import ComponentCatalog

extension HostedRenderingTests {
    private var root: URL {
        URL(fileURLWithPath: #filePath).deletingLastPathComponent().deletingLastPathComponent().deletingLastPathComponent()
    }

    @Test("Catalogue IDs are unique and the documentation inventory stays current")
    func inventory() throws {
        let names = ContentView.Demo.allCases.map(\.rawValue)
        #expect(Set(names).count == names.count)
        let entries = ContentView.Demo.allCases.map { demo in
            ["name": demo.rawValue, "category": demo.category.rawValue,
             "image": demo.rawValue.lowercased().replacingOccurrences(of: " ", with: "-")]
        }
        if let export = ProcessInfo.processInfo.environment["CATALOGUE_EXPORT_PATH"] {
            try JSONSerialization.data(withJSONObject: entries, options: [.prettyPrinted, .sortedKeys])
                .write(to: URL(fileURLWithPath: export))
        }
        let data = try Data(contentsOf: root.appendingPathComponent("Documentation/Examples.json"))
        let documented = try #require(JSONSerialization.jsonObject(with: data) as? [[String: String]])
        #expect(documented == entries, "Regenerate Documentation/Examples.json from the catalogue inventory test")
    }

    @Test("Every public shape has a dedicated executable example")
    func publicShapeCoverage() throws {
        let source = root.appendingPathComponent("Sources/SwiftUIComponents")
        let files = try #require(FileManager.default.enumerator(at: source, includingPropertiesForKeys: nil))
        let expression = try NSRegularExpression(pattern: "public struct (\\w+): (?:MuscleMapShape|Shape)")
        for case let url as URL in files where url.pathExtension == "swift" {
            let text = try String(contentsOf: url, encoding: .utf8)
            for match in expression.matches(in: text, range: NSRange(text.startIndex..., in: text)) {
                let range = try #require(Range(match.range(at: 1), in: text))
                let name = String(text[range])
                if url.path.contains("/Muscle Map/") {
                    let side = url.path.contains("/Front/") ? "Front" : "Back"
                    #expect(MuscleShapeSample.allCases.contains { $0.constructor == "MuscleMap.\(side).\(name)()" },
                            "Missing individual example for \(side).\(name)")
                } else {
                    #expect(ShapeSample.allCases.contains { $0.rawValue == name }, "Missing example for \(name)")
                }
            }
        }
    }

    @Test("Every isolated anatomical preview has visible geometry inside its canvas", arguments: MuscleShapeSample.allCases)
    func anatomicalPreview(sample: MuscleShapeSample) {
        let canvas = CGRect(x: 10, y: 20, width: 280, height: 180)
        let path = FittedMuscleShape(sample: sample).path(in: canvas)
        #expect(!path.isEmpty)
        #expect(path.boundingRect.width > 0 && path.boundingRect.height > 0)
        #expect(canvas.insetBy(dx: -0.01, dy: -0.01).contains(path.boundingRect))
    }

    @Test("Every catalogue route mounts and renders visible content", arguments: ContentView.Demo.allCases)
    func demoScreen(demo: ContentView.Demo) async throws {
        _ = NSApplication.shared
        let window = NSWindow(contentRect: CGRect(x: -2000, y: -2000, width: 500, height: 700),
                              styleMask: [.borderless], backing: .buffered, defer: false)
        window.isReleasedWhenClosed = false
        let host = NSHostingView(rootView: ContentView().destination(demo))
        window.contentView = host
        window.orderFront(nil)
        defer { window.close() }
        let image = try #require(host.bitmapImageRepForCachingDisplay(in: host.bounds))
        let deadline = ContinuousClock.now.advanced(by: .seconds(2))
        repeat {
            host.layoutSubtreeIfNeeded()
            host.cacheDisplay(in: host.bounds, to: image)
            if hasVariedPixels(image) { break }
            try await Task.sleep(for: .milliseconds(20))
        } while ContinuousClock.now < deadline
        #expect(hasVariedPixels(image), "The example rendered an empty surface")
    }

    /// Detects blank rendering without depending on colors, fonts or a specific OS theme.
    private func hasVariedPixels(_ image: NSBitmapImageRep) -> Bool {
        guard let bytes = image.bitmapData, image.bitsPerPixel >= 8,
              image.pixelsWide > 0, image.pixelsHigh > 0 else { return false }
        let stride = image.bitsPerPixel / 8
        for y in 0..<image.pixelsHigh {
            for x in 0..<image.pixelsWide {
                let index = y * image.bytesPerRow + x * stride
                if (0..<stride).contains(where: { bytes[index + $0] != bytes[$0] }) { return true }
            }
        }
        return false
    }
}
#endif
