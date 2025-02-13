// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

@preconcurrency import PackageDescription

let package = Package(
    name: .OrderBook,
    platforms: [
        .iOS(.v15),
    ],
    products: [
        .OrderBookInterface,
        .OrderBook,
        .OrderBookPreview,
    ],
    dependencies: [
        .package(path: "../AppRoot"),
        .package(path: "../Core"),
    ],
    targets: [
        .OrderBookInterface,
        .OrderBook,
        .OrderBookTesting,
        .OrderBookTests,
        .OrderBookPreview,
    ]
)

extension Product {
    // MARK: - Interface
    
    static let OrderBookInterface: Product = .library(
        name: .Interface.OrderBook,
        targets: [.Interface.OrderBook]
    )
    
    // MARK: - Feature
    
    static let OrderBook: Product = .library(
        name: .OrderBook,
        targets: [.OrderBook]
    )
    
    // MARK: - Preview
    
    static let OrderBookPreview: Product = .executable(
        name: .Preview.OrderBook,
        targets: [.Preview.OrderBook]
    )
}

extension Target {
    // MARK: - Interface
    
    static let OrderBookInterface: Target = .interface(
        name: .OrderBook,
        dependencies: [
            .product(name: "CoreDomain", package: "Core"),
        ]
    )
    
    // MARK: - Feature
    
    static let OrderBook: Target = .feature(
        name: .OrderBook,
        dependencies: [
            .Interface.OrderBook,
            .product(name: "AppRootInterface", package: "AppRoot"),
            .product(name: "CoreUtils", package: "Core"),
            .product(name: "CoreNetworkInterface", package: "Core"),
            .product(name: "CoreUI", package: "Core"),
            .product(name: "CoreDomain", package: "Core"),
        ]
    )
    
    // MARK: - Testing
    
    static let OrderBookTesting: Target = .testing(
        name: .OrderBook,
        dependencies: [
            .Interface.OrderBook,
        ]
    )
    
    // MARK: - Tests
    
    static let OrderBookTests: Target = .tests(
        name: .OrderBook,
        dependencies: [
            .Interface.OrderBook,
            .OrderBook,
            .Testing.OrderBook,
        ]
    )
    
    // MARK: - Preview
    
    static let OrderBookPreview: Target = .preview(
        name: .OrderBook,
        dependencies: [
            .OrderBook,
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
            path: .Tests.suffix
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
    static let OrderBook = byName(name: .OrderBook)
    
    enum Interface {
        static let OrderBook = byName(name: .Interface.OrderBook)
    }
    
    enum Testing {
        static let OrderBook = byName(name: .Testing.OrderBook)
    }
    
    enum Tests {
        static let OrderBook = byName(name: .Tests.OrderBook)
    }
    
    enum Preview {
        static let OrderBook = byName(name: .Preview.OrderBook)
    }
}

extension String {
    static let OrderBook = "OrderBook"
    
    enum Interface {
        static let OrderBook = .OrderBook + Self.suffix
        
        static let suffix = "Interface"
    }
    
    enum Implementation {
        static let suffix = "Implementation"
    }
    
    enum Testing {
        static let OrderBook = .OrderBook + suffix
        
        static let suffix = "Testing"
    }
    
    enum Tests {
        static let OrderBook = .OrderBook + Self.suffix
        
        static let suffix = "Tests"
    }
    
    enum Preview {
        static let OrderBook = .OrderBook + Self.suffix
        
        static let suffix = "Preview"
    }
}
