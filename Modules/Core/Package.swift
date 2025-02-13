// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

@preconcurrency import PackageDescription

let package = Package(
    name: .Core,
    platforms: [
        .iOS(.v15),
    ],
    products: [
        .CoreDomain,
        .CoreUI,
        .CoreUtils,
        
        .CoreNetworkInterface,
        .CoreNetwork,
    ],
    dependencies: [
        .package(url: "https://github.com/Swinject/Swinject.git", exact: "2.9.1"),
        .package(url: "https://github.com/apple/swift-collections.git", .upToNextMajor(from: "1.1.4")),
    ],
    targets: [
        .CoreDomain,
        .CoreUI,
        .CoreUtils,
        
        .CoreNetworkInterface,
        .CoreNetwork,
        .CoreNetworkTesting,
        .CoreNetworkTests,
    ]
)

extension Product {
    
    static let CoreDomain: Product = .library(
        name: .CoreDomain,
        targets: [.CoreDomain]
    )
    
    static let CoreUI: Product = .library(
        name: .CoreUI,
        targets: [.CoreUI]
    )
    
    static let CoreUtils: Product = .library(
        name: .CoreUtils,
        targets: [.CoreUtils]
    )
    
    static let CoreNetworkInterface: Product = .library(
        name: .Interface.CoreNetwork,
        targets: [.Interface.CoreNetwork]
    )
    
    static let CoreNetwork: Product = .library(
        name: .CoreNetwork,
        targets: [.CoreNetwork]
    )
}

extension Target {
    
    // MARK: - Core
    
    static let CoreDomain: Target = .core(
        name: .CoreDomain
    )
    
    static let CoreUI: Target = .core(
        name: .CoreUI,
        dependencies: [
            .CoreUtils,
        ]
    )
    
    static let CoreUtils: Target = .core(
        name: .CoreUtils,
        dependencies: [
            "Swinject",
            .product(name: "OrderedCollections", package: "swift-collections"),
        ]
    )
    
    // MARK: - Interface
    
    static let CoreNetworkInterface: Target = .interface(
        name: .CoreNetwork,
        dependencies: [
            .CoreDomain,
        ]
    )
    
    // MARK: - Implementation
    
    static let CoreNetwork: Target = .implementation(
        name: .CoreNetwork,
        dependencies: [
            .Interface.CoreNetwork,
            .CoreUtils,
        ]
    )
    
    // MARK: - Testing
    
    static let CoreNetworkTesting: Target = .testing(
        name: .CoreNetwork,
        dependencies: [
            .Interface.CoreNetwork,
        ]
    )
    
    // MARK: - Tests
    
    static let CoreNetworkTests: Target = .tests(
        name: .CoreNetwork,
        dependencies: [
            .Interface.CoreNetwork,
            .CoreNetwork,
            .Testing.CoreNetwork,
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
            path: "Sources/\(name)/" + .Interface.suffix
        )
    }
    
    static func implementation(
        name: String,
        dependencies: [Target.Dependency] = []
    ) -> Target {
        .target(
            name: name,
            dependencies: dependencies,
            path: "Sources/\(name)/" + .Implementation.suffix
        )
    }
    
    static func testing(
        name: String,
        dependencies: [Target.Dependency] = []
    ) -> Target {
        .target(
            name: name + .Testing.suffix,
            dependencies: dependencies,
            path: "Sources/\(name)/" + .Testing.suffix
        )
    }
    
    static func core(
        name: String,
        dependencies: [Target.Dependency] = []
    ) -> Target {
        .target(
            name: name,
            dependencies: dependencies,
            path: "Sources/\(name)"
        )
    }
    
    static func tests(
        name: String,
        dependencies: [Target.Dependency] = []
    ) -> Target {
        .testTarget(
            name: name + .Tests.suffix,
            dependencies: dependencies,
            path: "Tests/\(name)Tests"
        )
    }
}

extension Target.Dependency {
    static let CoreNetwork = byName(name: .CoreNetwork)
    static let CoreDomain = byName(name: .CoreDomain)
    static let CoreUI = byName(name: .CoreUI)
    static let CoreUtils = byName(name: .CoreUtils)
    
    enum Interface {
        static let CoreNetwork = byName(name: .Interface.CoreNetwork)
    }
    
    enum Testing {
        static let CoreNetwork = byName(name: .Testing.CoreNetwork)
    }
    
    enum Tests {
        static let CoreNetwork = byName(name: .Tests.CoreNetwork)
    }
}

extension String {
    static let Core = "Core"
    
    static let CoreNetwork = "CoreNetwork"
    static let CoreDomain = "CoreDomain"
    static let CoreUI = "CoreUI"
    static let CoreUtils = "CoreUtils"
    
    enum Interface {
        static let CoreNetwork = .CoreNetwork + suffix
        
        static let suffix = "Interface"
    }
    
    enum Implementation {
        static let suffix = "Implementation"
    }
    
    enum Testing {
        static let CoreNetwork = .CoreNetwork + suffix
        
        static let suffix = "Testing"
    }
    
    enum Tests {
        static let CoreNetwork = .CoreNetwork + suffix
        
        static let suffix = "Tests"
    }
}
