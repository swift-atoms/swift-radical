// swift-tools-version: 6.4
import PackageDescription

let package = Package(
    name: "swift-radical",
    platforms: [.macOS(.v27), .iOS(.v27), .tvOS(.v27), .watchOS(.v27), .visionOS(.v27)],
    products: [
        .library(name: "Radical", targets: ["Radical"]),

        .library(name: "Radical Foundation Integration", targets: ["Radical Foundation Integration"]),
        .library(name: "Radical Test Support", targets: ["Radical Test Support"]),
    ],
    dependencies: [.package(url: "https://github.com/swift-atoms/swift-rational.git", branch: "main")],
    targets: [
        .target(name: "Radical", dependencies: [.product(name: "Rational", package: "swift-rational")], path: "Sources/Radical"),
        .target(name: "Radical Foundation Integration", dependencies: ["Radical"], path: "Sources/Radical Foundation Integration"),
        .target(name: "Radical Test Support", dependencies: ["Radical"], path: "Tests/Support"),
        .testTarget(name: "Radical Tests", dependencies: ["Radical", "Radical Foundation Integration", "Radical Test Support"], path: "Tests/Radical Tests"),
    ],
    swiftLanguageModes: [.v6]
)

for target in package.targets {
    target.swiftSettings = [
        .strictMemorySafety(),
        .enableUpcomingFeature("ExistentialAny"),
        .enableUpcomingFeature("InternalImportsByDefault"),
        .enableUpcomingFeature("MemberImportVisibility"),
        .enableUpcomingFeature("NonisolatedNonsendingByDefault"),
        .enableExperimentalFeature("Lifetimes"),
        .enableUpcomingFeature("InferIsolatedConformances"),
    ]
}
