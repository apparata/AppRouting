//
//  Copyright © 2025 Apparata AB. All rights reserved.
//

import SwiftUI

/// A container for managing multiple ``Router`` instances by their routing type.
/// Enables access to and coordination between different routing contexts.
///
/// Typically used in conjunction with ``MetaRouting`` to provide seamless cross-context navigation.
///
@Observable @MainActor public class MetaRouter {

    /// A dictionary mapping unique routing type keys to their associated ``KeyableRouter`` instances.
    @ObservationIgnored
    public let routers: [RoutingTypeKey: any KeyableRouter]

    /// Initializes the `MetaRouter` with a ``RoutingContextTree``, extracting routers from it.
    /// - Parameter tree: A hierarchical tree representing the routing structure.
    public init(tree: RoutingContextTree) {
        routers = tree.routersByType()
    }

    /// Initializes the `MetaRouter` using a result builder for a declarative routing context.
    /// - Parameter builder: A closure that returns a root ``RoutingContext`` node.
    public init(@RoutingContextTreeBuilder _ builder: () -> RoutingContext) {
        routers = RoutingContextTree(builder()).routersByType()
    }

    /// Retrieves a ``Router`` instance for the specified routing type.
    /// - Parameter routingType: The type conforming to ``Routing`` for which to retrieve the router.
    /// - Returns: A strongly typed ``Router`` for the given routing type.
    public func router<T: Routing>(for routingType: T.Type) -> Router<T> {
        let routerKey = RoutingTypeKey(routingType)
        let router = routers[routerKey] as! Router<T>
        return router
    }

    /// Creates a ``MetaRouting`` instance for a specific routing type.
    /// - Parameter routingType: The type conforming to ``Routing`` for which to create the meta routing.
    /// - Returns: A ``MetaRouting`` instance enabling navigation and context switching for the specified type.
    public func routing<T: Routing>(_ routingType: T.Type) -> MetaRouting<T> {
        let routerKey = RoutingTypeKey(routingType)
        let router = routers[routerKey] as! Router<T>
        return MetaRouting(router, metaRouter: self)
    }
}
