// swift-tools-version: 6.1

import PackageDescription

let package = Package(
    name: "QuickLooking",
    platforms: [
        .macOS(.v14),
        .iOS(.v13)
    ],
    products: [
        // Executables & libraries a package produces
        // Visible to other packages
        .library(
            name: "QuickLooking",
            targets: ["QuickLooking"]
        )
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite
        // Targets can depend on other targets in this package and products from dependencies
        .target(name: "QuickLooking")
    ]
)
