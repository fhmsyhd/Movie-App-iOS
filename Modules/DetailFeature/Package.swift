// swift-tools-version:5.9
import PackageDescription

let package = Package(
    name: "DetailFeature",
    platforms: [
        .iOS(.v16)
    ],
    products: [
        .library(
            name: "DetailFeature",
            targets: ["DetailFeature"]
        )
    ],
    dependencies: [
        .package(path: "../MovieAppCore"),
        .package(path: "../CommonUI")
    ],
    targets: [
        .target(
            name: "DetailFeature",
            dependencies: ["MovieAppCore", "CommonUI"],
            path: "Sources/DetailFeature"
        )
    ]
)
