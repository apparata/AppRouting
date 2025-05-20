//
//  Copyright © 2025 Apparata AB. All rights reserved.
//

import SwiftUI

/// Convenience button that wraps an `@Environment` for providing
/// the router instance, corresponding to the given ``Routing``, to the action closure.
///
/// **Example:**
///
/// Let's assume that this button is already part of the product list tab.
///
/// ```swift
/// RoutingButton(MainRouting.self) { router in
///     router.push(.productDetails(productID: "12532"))
/// } label: {
///     Text("Details")
/// }
/// .buttonStyle(.borderedProminent)
/// ```
///
/// If the button is somewhere else, and we want to make sure the correct tab is selected first,
/// we can chain the routing functions.
///
/// ```swift
/// RoutingButton(MainRouting.self) { router in
///     router
///         .select(.productsTab)
///         .push(.productDetails(productID: "12532"))
/// } label: {
///     Text("Details")
/// }
/// .buttonStyle(.borderedProminent)
/// ```
///
public struct RoutingButton<R: Routing, Label: View>: View {

    @Environment(Router<R>.self) private var router

    private let action: (Router<R>) -> Void
    private let label: Label

    /// Creates a `RoutingButton` that uses the environment-injected router for the specified `Routing` type.
    ///
    /// - Parameters:
    ///   - routing: The root routing type to associate this button with.
    ///   - action: A closure that receives the environment-injected `Router` and performs navigation operations.
    ///   - label: A view builder that provides the content of the button.
    ///   
    @preconcurrency public init(
        _ routing: R.Type,
        action: @escaping @MainActor (Router<R>) -> Void,
        @ViewBuilder label: () -> Label
    ) {
        self.action = action
        self.label = label()
    }

    public var body: some View {
        Button {
            action(router)
        } label: {
            label
        }
    }
}
