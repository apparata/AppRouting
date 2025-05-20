//
//  Copyright © 2025 Apparata AB. All rights reserved.
//

import SwiftUI

/// A wrapper around `Router` that uses a builder-like interface for switching routing context.
/// Allows navigation within a routing context while enabling access to other routing types.
///
/// - Note: This class is intended to be used in conjunction with `MetaRouter`.
///
@MainActor public class MetaRouting<T: Routing> {

    private let router: Router<T>
    private let metaRouter: MetaRouter

    /// Initializes a new `MetaRouting` instance.
    ///
    /// - Parameters:
    ///   - router: The router for the current routing type.
    ///   - metaRouter: The shared `MetaRouter` for cross-routing operations.
    ///
    init(_ router: Router<T>, metaRouter: MetaRouter) {
        self.router = router
        self.metaRouter = metaRouter
    }

    /// Accesses a different routing context via the `MetaRouter`.
    ///
    /// - Parameter routerType: The type of the routing context to access.
    /// - Returns: A `MetaRouting` instance for the requested routing type.
    ///
    public func routing<R: Routing>(_ routerType: R.Type) -> MetaRouting<R> {
        metaRouter.routing(routerType)
    }

    /// Selects a value using the current router.
    ///
    /// - Parameter selectable: Value conforming to `Selectable` type of current routing type.
    /// - Returns: The current `MetaRouting` instance for method chaining.
    ///
    @discardableResult
    public func select(_ selectable: T.Selectable) -> MetaRouting<T> {
        router.select(selectable)
        return self
    }

    /// Pushes a value onto the navigation stack using the current router.
    ///
    /// - Parameter pushable: Value conforming to `Pushable` type of current routing type.
    /// - Returns: The current `MetaRouting` instance for method chaining.
    ///
    @discardableResult
    public func push(_ pushable: T.Pushable) -> MetaRouting<T> {
        router.push(pushable)
        return self
    }

    /// Presents a value in a sheet using the current router.
    ///
    /// - Parameter presentable: Value conforming to `Presentable` type current routing type.
    /// - Returns: The current `MetaRouting` instance for method chaining.
    ///
    @discardableResult
    public func presentSheet(_ presentable: T.Presentable) -> MetaRouting<T> {
        router.presentSheet(presentable)
        return self
    }

    /// Presents a value in a full screen cover using the current router.
    ///
    /// - Parameter presentable: Value conforming to `Presentable` of current routing type.
    /// - Returns: The current `MetaRouting` instance for method chaining.
    ///
    @discardableResult
    public func presentFullScreenCover(_ presentable: T.Presentable) -> MetaRouting<T> {
        router.presentFullScreenCover(presentable)
        return self
    }
}
