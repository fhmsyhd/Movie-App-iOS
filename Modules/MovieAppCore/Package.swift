// swift-tools-version:5.9
import PackageDescription

let package = Package(
    name: "MovieAppCore",
    platforms: [
        .iOS(.v16)
    ],
    products: [
        .library(
            name: "MovieAppCore",
            targets: ["MovieAppCore"]
        )
    ],
    targets: [
        .target(
            name: "MovieAppCore",
            path: "Sources/MovieAppCore"
        )
    ]
)
