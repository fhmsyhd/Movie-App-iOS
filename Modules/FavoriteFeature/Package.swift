// swift-tools-version:5.9
import PackageDescription

let package = Package(
    name: "FavoriteFeature",
    platforms: [
        .iOS(.v16)
    ],
    products: [
        .library(
            name: "FavoriteFeature",
            targets: ["FavoriteFeature"]
        )
    ],
    dependencies: [
        .package(path: "../MovieAppCore"),
        .package(path: "../CommonUI"),
        .package(path: "../DetailFeature")
    ],
    targets: [
        .target(
            name: "FavoriteFeature",
            dependencies: ["MovieAppCore", "CommonUI", "DetailFeature"],
            path: "Sources/FavoriteFeature"
        )
    ]
)
