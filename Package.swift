// swift-tools-version: 6.3

import PackageDescription

// Apple clients use system SwiftUI. Skip's host bridge generation also needs the Android renderer metadata.
let needsSkipMetadata = (Context.environment["SKIP_DYNAMIC_LIBRARIES"] ?? "0") != "0"
    || (Context.environment["SKIP_BRIDGE"] ?? "0") != "0"
let skipUICondition: TargetDependencyCondition? = needsSkipMetadata ? nil : .when(platforms: [.android])

let package = Package(
    name: "SwiftUIComponents",
    defaultLocalization: "en",
    platforms: [.iOS(.v18), .macOS(.v15), .tvOS(.v18), .watchOS(.v11), .macCatalyst(.v18)],
    products: [
        .library(
            name: "SwiftUIComponents",
            targets: ["SwiftUIComponents"]),
        .executable(name: "ComponentCatalogDemo", targets: ["ComponentCatalogRunner"]),
        .library(name: "ComponentCatalog", type: .dynamic, targets: ["ComponentCatalog"]),
    ],
    dependencies: [
        .package(url: "https://github.com/skiptools/skip.git", from: "1.9.2"),
        .package(url: "https://github.com/skiptools/skip-fuse-ui.git", from: "1.9.1"),
    ],
    targets: [
        .target(name: "SwiftUIComponents", dependencies: [
            .product(name: "SkipFuseUI", package: "skip-fuse-ui", condition: skipUICondition),
        ], plugins: [.plugin(name: "skipstone", package: "skip")]),
        .target(
            name: "ComponentCatalog",
            dependencies: ["SwiftUIComponents"],
            path: "Examples/Examples",
            exclude: ["Assets.xcassets", "Preview Content", "Examples.entitlements", "ExamplesApp.swift"],
            plugins: [.plugin(name: "skipstone", package: "skip")]
        ),
        .executableTarget(name: "ComponentCatalogRunner", dependencies: ["ComponentCatalog"], path: "Examples/Launcher"),
        .testTarget(
            name: "SwiftUIComponentsTests",
            dependencies: [
                "SwiftUIComponents",
                .target(name: "ComponentCatalog", condition: .when(platforms: [.macOS])),
            ],
            exclude: ["Skip"]
        ),
    ],
    swiftLanguageModes: [.v6]
)
