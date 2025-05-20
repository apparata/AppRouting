//
//  Copyright © 2025 Apparata AB. All rights reserved.
//

import SwiftUI

/// Convenience button that wraps an `@Environment` for providing
/// the ``MetaRouter`` instance, corresponding to the given root ``Routing``,
/// to the action closure.
///
/// **Example:**
///
/// ```swift
/// MetaRoutingButton(MainRouting.self) { metaRouting in
///     metaRouting
///         .select(.profileTab)
///         .presentSheet(.settings)
///         .routing(SettingsRouting.self)
///         .dismissPresentables()
///         .push(.attributions)
/// } label: {
///     Text("Attributions")
/// }
/// .buttonStyle(.borderedProminent)
/// ```
///
public struct MetaRoutingButton<R: Routing, Label: View>: View {

    @Environment(MetaRouter.self) private var metaRouter

    private let routing: R.Type
    private let action: (MetaRouting<R>) -> Void
    private let label: Label

    /// Creates a `MetaRoutingButton` for a specific `Routing` type.
    ///
    /// - Parameters:
    ///   - routing: The root routing type used to create a `MetaRouting` instance.
    ///   - action: A closure that receives a `MetaRouting` instance scoped to the provided routing type,
    ///             allowing chaining of routing operations.
    ///   - label: A view builder that provides the button's label content.
    ///   
    @preconcurrency public init(
        _ routing: R.Type,
        action: @escaping @MainActor (MetaRouting<R>) -> Void,
        @ViewBuilder label: () -> Label
    ) {
        self.routing = routing
        self.action = action
        self.label = label()
    }

    public var body: some View {
        Button {
            action(metaRouter.routing(routing))
        } label: {
            label
        }
    }
}
