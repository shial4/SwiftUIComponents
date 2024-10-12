// swift-tools-version: 5.9

import PackageDescription

let package = Package(
    name: "SwiftUIComponents",
    defaultLocalization: "en",
    platforms: [.iOS(.v16), .macOS(.v13), .tvOS(.v16), .watchOS(.v9), .macCatalyst(.v16)],
    products: [
        .library(
            name: "SwiftUIComponents",
            targets: ["SwiftUIComponents"]),
    ],
    dependencies: [
        .package(url: "https://source.skip.tools/skip.git", from: "1.1.10"),
        .package(url: "https://source.skip.tools/skip-ui.git", from: "1.11.2"),
        .package(url: "https://source.skip.tools/skip-foundation.git", from: "1.0.0"),
    ],
    targets: [
        .target(
            name: "SwiftUIComponents",
            dependencies: [
                .product(name: "SkipUI", package: "skip-ui"),
                .product(name: "SkipFoundation", package: "skip-foundation"),
            ],
            plugins: [.plugin(name: "skipstone", package: "skip")]
        ),
        .testTarget(
            name: "SwiftUIComponentsTests",
            dependencies: [
                "SwiftUIComponents",
                .product(name: "SkipTest", package: "skip")
            ],
            plugins: [.plugin(name: "skipstone", package: "skip")]
        ),
    ]
)
