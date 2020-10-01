// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "doordeck-sdk-swift",
    defaultLocalization: "en",
    platforms: [
        .iOS(.v11)
    ],
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "doordeck-sdk-swift",
            targets: ["doordeck-sdk-swift"]),
    ],
    dependencies: [
        .package(
            name: "QRCodeReader",
            url: "https://github.com/yannickl/QRCodeReader.swift.git",
            from: "10.1.1"
        ),
        .package(
            name: "Reachability",
            url: "https://github.com/ashleymills/Reachability.swift",
            from: "5.1.0"
        ),
        .package(
            name: "Alamofire",
            url: "https://github.com/Alamofire/Alamofire",
            from: "5.2.2"
        ),
        .package(
            name: "Cache",
            url: "https://github.com/hyperoslo/Cache",
            from: "5.3.0"
        ),
        .package(
            name: "Sodium",
            url: "https://github.com/jedisct1/swift-sodium",
            from: "0.9.0"
        )
        
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .target(
            name: "doordeck-sdk-swift",
            dependencies: ["QRCodeReader","Reachability","Alamofire","Cache","Sodium"]),
        .testTarget(
            name: "doordeck-sdk-swiftTests",
            dependencies: ["doordeck-sdk-swift"]),
    ]
)
