// swift-tools-version:5.0
import PackageDescription

let package = Package(
    name: "HarmonicNetwork",
    dependencies: [
        .package(url: "https://github.com/dn-m/Structure", from: "0.24.1"),
        .package(url: "https://github.com/dn-m/Music", from: "0.16.0"),
        .package(url: "https://github.com/dn-m/NotationModel", from: "0.9.0"),
        .package(url: "https://github.com/dn-m/Math", from: "0.8.0"),
        .package(url: "https://github.com/dn-m/Graphics", from: "0.2.0"),
        .package(url: "https://github.com/vapor/console-kit", .upToNextMinor(from: "3.1.1")),
        .package(url: "https://github.com/vapor/vapor.git", .upToNextMinor(from: "3.3.0")),
    ],
    targets: [
        .target(
            name: "HarmonicNetworkCore",
            dependencies: ["DataStructures", "Pitch", "Math", "SpelledPitch", "Geometry"]
        ),
        .target(
            name: "harmonic-network-webapp",
            dependencies: ["Vapor"]
        ),
        .target(
            name: "harmonic-network-server",
            dependencies: ["harmonic-network-webapp"]
        ),
        .target(
            name: "harmonic-network-cli",
            dependencies: ["DataStructures", "Pitch", "Math", "SpelledPitch", "Console", "Logging", "Command"]
        ),
        .testTarget(
            name: "HarmonicNetworkCoreTests",
            dependencies: ["HarmonicNetworkCore"]
        ),
    ]
)
