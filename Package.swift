// swift-tools-version: 5.8
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "view-state-based-swiftui",
    platforms: [.iOS(.v15)],
    products: [
        .library(name: "ViewStateBasedSwiftUI", targets: ["ViewStateBasedSwiftUI"])
    ],
    dependencies: [],
    targets: [
        .target(
            name: "ViewStateBasedSwiftUI",
            path: "Sources"
        )
    ]
)
