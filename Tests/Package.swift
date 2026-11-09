// swift-tools-version: 6.3
import PackageDescription

// Run the same logic tests on Android without building the desktop launcher or
// Apple rendering harness. The root package continues to run both test groups.
let package = Package(
    name: "SwiftUIComponentsLogicTests",
    platforms: [.macOS(.v15)],
    dependencies: [
        .package(name: "SwiftUIComponents", path: ".."),
        .package(url: "https://github.com/skiptools/skip.git", from: "1.9.20"),
    ],
    targets: [
        .testTarget(
            name: "SwiftUIComponentsTests",
            dependencies: [
                .product(name: "SwiftUIComponents", package: "SwiftUIComponents"),
                .product(name: "SkipTest", package: "skip"),
            ],
            path: "SwiftUIComponentsTests",
            plugins: [.plugin(name: "skipstone", package: "skip")]
        )
    ],
    swiftLanguageModes: [.v6]
)
