// swift-tools-version:5.9
import PackageDescription

let package = Package(
    name: "AboutFeature",
    platforms: [
        .iOS(.v16)
    ],
    products: [
        .library(
            name: "AboutFeature",
            targets: ["AboutFeature"]
        )
    ],
    targets: [
        .target(
            name: "AboutFeature",
            path: "Sources/AboutFeature"
        )
    ]
)
