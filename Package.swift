// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "composable-authentication-services",
    platforms: [.macOS(.v10_15), .iOS(.v13)],
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "ComposableAuthenticationServices",
            targets: ["ComposableAuthenticationServices"]
        ),
    ],
    dependencies: [
        .package(
          url: "https://github.com/pointfreeco/swift-composable-architecture",
          branch: "concurrency-beta"
        )
    ],
    targets: [
        .target(
            name: "ComposableAuthenticationServices",
            dependencies: [
                .product(name: "ComposableArchitecture", package: "swift-composable-architecture")
            ]
        ),
        .testTarget(
            name: "ComposableAuthenticationServicesTests",
            dependencies: ["ComposableAuthenticationServices"]),
    ]
)
