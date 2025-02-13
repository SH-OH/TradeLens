// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

@preconcurrency import PackageDescription

let package = Package(
    name: .AppRoot,
    platforms: [
        .iOS(.v15)
    ],
    products: [
         .AppRootInterface,
         .AppRoot,
    ],
    dependencies: [
        .package(path: "../OrderBook"),
        .package(path: "../RecentTrades"),
        .package(path: "../Core")
    ],
    targets: [
         .AppRootInterface,
         .AppRoot,
    ]
)

extension Product {
    // MARK: - Interface
    
    static let AppRootInterface: Product = .library(
        name: .Interface.AppRoot,
        targets: [.Interface.AppRoot]
    )
    
    // MARK: - Feature
    
    static let AppRoot: Product = .library(
        name: .AppRoot,
        targets: [.AppRoot]
    )
}

extension Target {
    
    // MARK: - Interface
    
    static let AppRootInterface: Target = .interface(
        name: .AppRoot,
        dependencies: [
            .product(name: "CoreUtils", package: "Core"),
        ]
    )
    
    // MARK: - Feature
    
    static let AppRoot: Target = .feature(
        name: .AppRoot,
        dependencies: [
            .Interface.AppRoot,
            "OrderBook",
            "RecentTrades",
            .product(name: "CoreNetworkInterface", package: "Core"),
            .product(name: "CoreNetwork", package: "Core"),
            .product(name: "CoreUtils", package: "Core"),
        ]
    )
    
    // MARK: - Tests
    
    static let AppRootTests: Target = .tests(
        name: .AppRoot,
        dependencies: []
    )
}

// MARK: - Helper

extension Target {
    static func interface(
        name: String,
        dependencies: [Target.Dependency] = []
    ) -> Target {
        .target(
            name: name + .Interface.suffix,
            dependencies: dependencies,
            path: .Interface.suffix
        )
    }
    
    static func feature(
        name: String,
        dependencies: [Target.Dependency] = []
    ) -> Target {
        .target(
            name: name,
            dependencies: dependencies,
            path: "Sources"
        )
    }
    
    static func tests(
        name: String,
        dependencies: [Target.Dependency] = []
    ) -> Target {
        let suffixedName = name + .Tests.suffix
        return .testTarget(
            name: suffixedName,
            dependencies: dependencies,
            path: "Tests"
        )
    }
}

extension Target.Dependency {
    static let AppRoot = byName(name: .AppRoot)
    
    enum Interface {
        static let AppRoot = byName(name: .Interface.AppRoot)
    }
    
    enum Tests {
        static let AppRoot = byName(name: .Tests.AppRoot)
    }
}

extension String {
    static let AppRoot = "AppRoot"
    
    enum Interface {
        static let AppRoot = .AppRoot + Self.suffix
        
        static let suffix = "Interface"
    }
    
    enum Tests {
        static let AppRoot = .AppRoot + Self.suffix
        
        static let suffix = "Tests"
    }
}
