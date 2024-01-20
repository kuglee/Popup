// swift-tools-version: 5.5

import PackageDescription

let package = Package(
    name: "Popup",
    platforms: [.iOS(.v15), .macOS(.v12), .tvOS(.v15), .watchOS(.v8)],
    products: [
        .library(
            name: "Popup",
            targets: ["Popup"]),
    ],
    dependencies: [
      .package(url: "https://github.com/kuglee/OnTapOutsideGesture", branch: "main"),
    ],
    targets: [
        .target(
            name: "Popup",
            dependencies: [
              .product(name: "OnTapOutsideGesture", package: "OnTapOutsideGesture"),
            ]
        ),
        .testTarget(
            name: "PopupTests",
            dependencies: ["Popup"]),
    ]
)
