// swift-tools-version:5.9
import PackageDescription

let package = Package(
    name: "CommonUI",
    platforms: [
        .iOS(.v16)
    ],
    products: [
        .library(
            name: "CommonUI",
            targets: ["CommonUI"]
        )
    ],
    dependencies: [
        .package(path: "../MovieAppCore")
    ],
    targets: [
        .target(
            name: "CommonUI",
            dependencies: ["MovieAppCore"],
            path: "Sources/CommonUI"
        )
    ]
)
