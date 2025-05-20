//
//  Copyright © 2025 Apparata AB. All rights reserved.
//

import SwiftUI

// MARK: - Routing Context Tree

/// A tree structure used to manage a hierarchy of routing contexts.
@MainActor public class RoutingContextTree {

    /// The root node of the routing context tree.
    public let root: RoutingContext

    /// Initializes a routing context tree using a result builder closure.
    public init(@RoutingContextTreeBuilder _ builder: () -> RoutingContext) {
        self.root = builder()
    }

    /// Initializes a routing context tree with a specified root node.
    public init(_ root: RoutingContext) {
        self.root = root
    }

    internal func routersByType() -> [RoutingTypeKey: any KeyableRouter] {
        var routers: [RoutingTypeKey: any KeyableRouter] = [:]
        routersByType(node: root, into: &routers)
        return routers
    }

    internal func routersByType(
        node: RoutingContext,
        into routers: inout [RoutingTypeKey: any KeyableRouter]
    ) {
        routers[node.type] = node.router
        for child in node.children {
            routersByType(node: child, into: &routers)
        }
    }
}

// MARK: - Routing Context Tree Builder

/// A result builder for creating the root context node of a `RoutingContextTree`.
@resultBuilder @MainActor public struct RoutingContextTreeBuilder {
    public static func buildBlock(_ components: RoutingContext) -> RoutingContext {
        return components
    }
}
