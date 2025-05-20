//
//  Copyright © 2025 Apparata AB. All rights reserved.
//

import SwiftUI

public extension View {

    /// Modifier that defines where sheets and full screen covers should be presented
    /// from by the router. While use is optional, it is strongly recommended that this
    /// modifier is used rather than `.sheet` and `.fullScreenCover`, because
    /// the router prefers to treat them as one unified presentation point.
    ///
    /// **Example:**
    ///
    /// ```swift
    /// myView
    ///     .presentableDestination(for: MyRoutingType.self) { presentable in
    ///         switch presentable {
    ///         case .helloWorld: Text("Hello, world!")
    ///         case .someOtherView: SomeOtherView()
    ///         }
    ///     }
    /// ```
    ///
    /// This example is equivalent to:
    ///
    /// ```swift
    /// @Environment(Router<R>.self) private var router
    /// // ...
    /// @Bindable var router = router
    /// myView
    ///     .sheet(item: $router.presentedSheet) { presentable in
    ///         presentableContent(presentable)
    ///     }
    ///     .fullScreenCover(item: $router.presentedFullScreenCover) { presentable in
    ///         presentableContent(presentable)
    ///     }
    /// ```
    ///
    /// - Parameters:
    ///   - routing: The routing context of the presentable destination.
    ///   - content: The views to choose from for the presentable destination.
    /// - Returns: The view corresponding to the destination.
    ///
    func presentableDestination<R: Routing, PresentableContent: View>(
        for routing: R.Type,
        @ViewBuilder content: @escaping (R.Presentable) -> PresentableContent
    ) -> some View {
        return modifier(
            PresentableDestinationModifier(
                for: routing,
                presentableContent: content
            )
        )
    }
}

/// See the `presentableDestination(for:content:)` modifier view extension.
public struct PresentableDestinationModifier<R: Routing, PresentableContent: View>: ViewModifier {

    private let presentableContent: (R.Presentable) -> PresentableContent

    @Environment(Router<R>.self) private var router

    public init(
        for routing: R.Type,
        @ViewBuilder presentableContent: @escaping (R.Presentable) -> PresentableContent
    ) {
        self.presentableContent = presentableContent
    }

    public func body(content: Content) -> some View {
        @Bindable var router = router
        content
            .sheet(item: $router.presentedSheet) { presentable in
                presentableContent(presentable)
            }
            #if !os(macOS)
            .fullScreenCover(item: $router.presentedFullScreenCover) { presentable in
                presentableContent(presentable)
            }
            #endif
    }
}
