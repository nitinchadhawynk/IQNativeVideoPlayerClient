// swift-tools-version:5.5
import PackageDescription

let package = Package(
    name: "IQNativeVideoPlayerClient",
    platforms: [
        .iOS(.v13),
        .tvOS(.v15)
    ],
    products: [
        .library(
            name: "IQNativeVideoPlayerClient",
            targets: ["IQNativeVideoPlayerClient"]
        )
    ],
    dependencies: [
        .package(
            url: "https://github.com/WynkLimited/IQVideoPlayer.git",
            from: "1.1.0"
        )
    ],
    targets: [
        .target(
            name: "IQNativeVideoPlayerClient",
            dependencies: [
                .product(name: "IQVideoPlayer", package: "IQVideoPlayer")
            ],
            path: "IQNativeVideoPlayerClient/Classes",
            exclude: [".gitkeep"]
        )
    ],
    swiftLanguageVersions: [.v5]
)
