// swift-tools-version:5.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Playgrounds",
    products: [
        .library(
            name: "Playgrounds",
            targets: ["Playgrounds"]),
    ],
    dependencies: [
        // Add packages here
        .package(url: "https://github.com/ReactiveX/RxSwift", from: "5.1.1")
    ],
    targets: [
        .target(
            name: "Playgrounds",
            dependencies: [
                // Add the libraries from the packages here
                .product(name: "RxSwift", package: "RxSwift"),
                .product(name: "RxCocoa", package: "RxSwift"),
                .product(name: "RxRelay", package: "RxSwift"),
                .product(name: "RxBlocking", package: "RxSwift"),
                .product(name: "RxTest", package: "RxSwift")
            ]
        ),
    ]
)
