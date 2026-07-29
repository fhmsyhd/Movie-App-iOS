// swift-tools-version:5.9
import PackageDescription

let package = Package(
    name: "HomeFeature",
    platforms: [
        .iOS(.v16)
    ],
    products: [
        .library(
            name: "HomeFeature",
            targets: ["HomeFeature"]
        )
    ],
    dependencies: [
        .package(path: "../MovieAppCore"),
        .package(path: "../CommonUI"),
        .package(path: "../DetailFeature")
    ],
    targets: [
        .target(
            name: "HomeFeature",
            dependencies: ["MovieAppCore", "CommonUI", "DetailFeature"],
            path: "Sources/HomeFeature"
        )
    ]
)
