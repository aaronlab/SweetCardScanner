// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SweetCardScanner",
    
    platforms: [.iOS(.v13)],
    
    products: [
        .library(
            name: "SweetCardScanner",
            type: .dynamic,
            targets: ["SweetCardScanner"]),
    ],
    
    dependencies: [
        .package(url: "https://github.com/yhkaplan/Reg.git", from: "0.3.0"),
    ],
    
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .target(
            name: "SweetCardScanner",
            dependencies: ["Reg"]),
        .testTarget(
            name: "SweetCardScannerTests",
            dependencies: ["SweetCardScanner"]),
    ]
)
