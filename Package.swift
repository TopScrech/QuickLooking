// swift-tools-version: 6.3.2

import PackageDescription

let package = Package(
    name: "QuickLooking",
    platforms: [
        .macOS(.v14),
        .iOS(.v13)
    ],
    products: [
        .library(name: "QuickLooking", targets: ["QuickLooking"])
    ],
    targets: [
        .target(name: "QuickLooking")
    ]
)
