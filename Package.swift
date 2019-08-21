// swift-tools-version:4.0
import PackageDescription

let package = Package(
    name: "HarmonicNetwork",
    dependencies: [
        .package(url: "https://github.com/dn-m/Structure", from: "0.24.1"),
        .package(url: "https://github.com/dn-m/Music", from: "0.16.0"),
        .package(url: "https://github.com/dn-m/NotationModel", from: "0.9.0"),
        .package(url: "https://github.com/dn-m/Math", from: "0.8.0"),
        .package(url: "https://github.com/dn-m/Graphics", from: "0.4.0"),
        .package(url: "https://github.com/vapor/vapor.git", .exact("3.3.0")),
        .package(url: "https://github.com/vapor/leaf.git", .upToNextMinor(from: "3.0.0")),
    ],
    targets: [
        .target(
            name: "HarmonicNetworkCore",
            dependencies: ["DataStructures", "Pitch", "Math", "SpelledPitch", "Geometry"]
        ),
        .target(
            name: "HarmonicNetworkWebApp",
            dependencies: [
                "DataStructures",
                "Geometry",
                "Rendering",
                "HarmonicNetworkCore",
                "Vapor",
                "Leaf"
            ]
        ),
        .target(
            name: "HarmonicNetworkServer",
            dependencies: ["HarmonicNetworkWebApp"]
        ),
        .target(
            name: "HarmonicNetworkCLI",
            dependencies: [
                "DataStructures",
                "Pitch",
                "Math",
                "SpelledPitch",
                "Vapor",
                "HarmonicNetworkCore"
            ]
        ),
        .testTarget(
            name: "HarmonicNetworkCoreTests",
            dependencies: ["DataStructures", "HarmonicNetworkCore"]
        ),
    ]
)
