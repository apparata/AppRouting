//
//  Copyright © 2025 Apparata AB. All rights reserved.
//

import SwiftUI

// MARK: - Routing Node

/// Routing tree context node containing a router and optional child contexts.
@MainActor public struct RoutingContext {

    /// The type key identifying the routing type of this context node.
    public let type: RoutingTypeKey

    /// The child nodes of this routing context node.
    public let children: [RoutingContext]

    /// The router associated with this routing context node.
    public let router: any KeyableRouter

    /// Initializes a routing context node with a type and optional children.
    public init<T: Routing>(_ type: T.Type, children: [RoutingContext] = []) {
        self.type = RoutingTypeKey(type)
        self.children = children
        self.router = Router<T>()
    }

    /// Initializes a routing context node using a result builder to define its children.
    public init<T: Routing>(_ type: T.Type, @RoutingContextsBuilder children: () -> [RoutingContext]) {
        self.type = RoutingTypeKey(type)
        self.children = children()
        self.router = Router<T>()
    }
}

// MARK: - Routing Nodes Builder

/// A result builder for constructing arrays of `RoutingContext` instances.
@resultBuilder @MainActor public struct RoutingContextsBuilder {
    public static func buildBlock(_ components: RoutingContext...) -> [RoutingContext] {
        return components
    }
}
