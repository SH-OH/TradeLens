// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

@preconcurrency import PackageDescription

let package = Package(
    name: .RecentTrades,
    platforms: [
        .iOS(.v15),
    ],
    products: [
        .RecentTradesInterface,
        .RecentTrades,
        .RecentTradesPreview,
    ],
    dependencies: [
        .package(path: "../AppRoot"),
        .package(path: "../Core"),
    ],
    targets: [
        .RecentTradesInterface,
        .RecentTrades,
        .RecentTradesTests,
        .RecentTradesPreview,
    ]
)

extension Product {
    // MARK: - Interface
    
    static let RecentTradesInterface: Product = .library(
        name: .Interface.RecentTrades,
        targets: [.Interface.RecentTrades]
    )
    
    // MARK: - Feature
    
    static let RecentTrades: Product = .library(
        name: .RecentTrades,
        targets: [.RecentTrades]
    )
    
    // MARK: - Preview
    
    static let RecentTradesPreview: Product = .executable(
        name: .Preview.RecentTrades,
        targets: [.Preview.RecentTrades]
    )
}

extension Target {
    // MARK: - Interface
    
    static let RecentTradesInterface: Target = .interface(
        name: .RecentTrades,
        dependencies: [
            .product(name: "CoreDomain", package: "Core"),
        ]
    )
    
    // MARK: - Feature
    
    static let RecentTrades: Target = .feature(
        name: .RecentTrades,
        dependencies: [
            .Interface.RecentTrades,
            .product(name: "AppRootInterface", package: "AppRoot"),
            .product(name: "CoreUtils", package: "Core"),
            .product(name: "CoreNetworkInterface", package: "Core"),
            .product(name: "CoreUI", package: "Core"),
            .product(name: "CoreDomain", package: "Core"),
        ]
    )
    
    // MARK: - Testing
    
    static let RecentTradesTesting: Target = .testing(
        name: .RecentTrades,
        dependencies: [
            .Interface.RecentTrades,
        ]
    )
    
    // MARK: - Tests
    
    static let RecentTradesTests: Target = .tests(
        name: .RecentTrades,
        dependencies: [
            .product(name: "CoreNetworkInterface", package: "Core"),
        ]
    )
    
    // MARK: - Preview
    
    static let RecentTradesPreview: Target = .preview(
        name: .RecentTrades,
        dependencies: [
            .RecentTrades,
        ]
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
            path: "Feature/" + .Interface.suffix
        )
    }
    
    static func feature(
        name: String,
        dependencies: [Target.Dependency] = []
    ) -> Target {
        .target(
            name: name,
            dependencies: dependencies,
            path: "Feature/" + .Implementation.suffix
        )
    }
    
    static func testing(
        name: String,
        dependencies: [Target.Dependency] = []
    ) -> Target {
        .target(
            name: name + .Testing.suffix,
            dependencies: dependencies,
            path: "Feature/" + .Testing.suffix
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
            path: .Testing.suffix
        )
    }
    
    static func preview(
        name: String,
        dependencies: [Target.Dependency] = []
    ) -> Target {
        return .executableTarget(
            name: name + .Preview.suffix,
            dependencies: dependencies,
            path: "Feature/Preview",
            swiftSettings: [
                .define("DEBUG")
            ]
        )
    }
}

extension Target.Dependency {
    static let RecentTrades = byName(name: .RecentTrades)
    
    enum Interface {
        static let RecentTrades = byName(name: .Interface.RecentTrades)
    }
    
    enum Testing {
        static let OrderBook = byName(name: .Testing.RecentTrades)
    }
    
    enum Tests {
        static let RecentTrades = byName(name: .Tests.RecentTrades)
    }
    
    enum Preview {
        static let RecentTrades = byName(name: .Preview.RecentTrades)
    }
}

extension String {
    static let RecentTrades = "RecentTrades"
    
    enum Interface {
        static let RecentTrades = .RecentTrades + Self.suffix
        
        static let suffix = "Interface"
    }
    
    enum Implementation {
        static let suffix = "Implementation"
    }
    
    enum Testing {
        static let RecentTrades = .RecentTrades + suffix
        
        static let suffix = "Testing"
    }
    
    enum Tests {
        static let RecentTrades = .RecentTrades + Self.suffix
        
        static let suffix = "Tests"
    }
    
    enum Preview {
        static let RecentTrades = .RecentTrades + Self.suffix
        
        static let suffix = "Preview"
    }
}
