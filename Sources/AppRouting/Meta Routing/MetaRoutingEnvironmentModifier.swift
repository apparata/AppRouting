//
//  Copyright © 2025 Apparata AB. All rights reserved.
//

import SwiftUI

extension View {

    /// Injects a router for the given `Routing` type from `MetaRouter` into the SwiftUI environment.
    ///
    /// - Note: This modifier depends on a `MetaRouter` from the environment.
    ///
    /// - Parameter routing: The routing type to be used.
    /// - Returns: A view modified with the MetaRoutingEnvironmentModifier.
    ///
    public func metaRoutingEnvironment<R: Routing>(_ routing: R.Type) -> some View {
        return modifier(MetaRoutingEnvironmentModifier(routing))
    }
}

/// Injects a router for the given `Routing` type from `MetaRouter` into the SwiftUI environment.
///
/// - Note: This modifier depends on a `MetaRouter` from the environment.
///
public struct MetaRoutingEnvironmentModifier<R: Routing>: ViewModifier {

    private let routing: R.Type

    @Environment(MetaRouter.self) private var metaRouter

    /// Creates a new MetaRoutingEnvironmentModifier for the specified routing type.
    /// - Parameter routing: The routing type to be injected into the environment.
    public init(_ routing: R.Type) {
        self.routing = routing
    }

    /// Modifies the content view by injecting the routing environment.
    /// - Parameter content: The content view to modify.
    /// - Returns: The modified view with the routing environment injected.
    public func body(content: Content) -> some View {
        content
            .environment(metaRouter.router(for: routing))
    }
}
