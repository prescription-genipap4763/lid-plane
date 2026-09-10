// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "LidPlane",
    platforms: [.macOS(.v13)],
    products: [.executable(name: "LidPlane", targets: ["LidPlane"])],
    targets: [
        .target(name: "LidPlaneCore"),
        .executableTarget(name: "LidPlane", dependencies: ["LidPlaneCore"]),
        .executableTarget(name: "LidPlaneChecks", dependencies: ["LidPlaneCore"], path: "Tests/LidPlaneCoreTests")
    ]
)
