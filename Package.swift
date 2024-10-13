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
    dependencies: [],
    targets: [
        .target(
            name: "SwiftUIComponents",
            dependencies: [],
            plugins: []
        ),
        .testTarget(
            name: "SwiftUIComponentsTests",
            dependencies: [
                "SwiftUIComponents",
            ],
            plugins: []
        ),
    ]
)
