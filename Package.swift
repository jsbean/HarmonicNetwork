// swift-tools-version:5.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "HarmonicPathfinder",
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        // .package(url: /* package url */, from: "1.0.0"),
        .package(url: "https://github.com/dn-m/Structure", from: "0.23.3"),
        .package(url: "https://github.com/dn-m/Music", from: "0.15.0"),
        .package(url: "https://github.com/dn-m/NotationModel", from: "0.8.0"),
        .package(url: "https://github.com/dn-m/Math", from: "0.7.1"),
        .package(url: "https://github.com/jsbean/console-kit", .branch("master"))
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages which this package depends on.
        .target(
            name: "HarmonicPathfinder",
            dependencies: ["DataStructures", "Pitch", "Math", "SpelledPitch", "ConsoleKit"]
        ),
        .testTarget(
            name: "HarmonicPathfinderTests",
            dependencies: ["HarmonicPathfinder"]),
    ]
)
