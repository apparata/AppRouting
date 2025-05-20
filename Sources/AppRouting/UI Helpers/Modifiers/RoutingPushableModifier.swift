//
//  Copyright © 2025 Apparata AB. All rights reserved.
//

import SwiftUI

public extension View {

    /// Convenience modifier that wraps `.navigationDestination()` to eliminate the need
    /// to specify `Pushable` as part of the type signature. Use is optional.
    /// 
    /// **Example:**
    /// 
    /// ```swift
    /// myView
    ///     .pushableDestination(for: MyRoutingType.self) { pushable in
    ///         switch pushable {
    ///         case .helloWorld: Text("Hello, world!")
    ///         case .someOtherView: SomeOtherView()
    ///         }
    ///     }
    /// ```
    /// 
    /// This example is equivalent to:
    /// 
    /// ```swift
    /// myView
    ///     .navigationDestination(for: MyRoutingType.Pushable.self) { pushable in
    ///         switch pushable {
    ///         case .helloWorld: Text("Hello, world!")
    ///         case .someOtherView: SomeOtherView()
    ///         }
    ///     }
    /// ```
    /// 
    /// - Parameters:
    ///   - routing: The routing context of the pushable destination.
    ///   - content: The views to choose from for the pushable destination.
    /// - Returns: The view corresponding to the destination.
    ///
    func pushableDestination<R: Routing, PresentableContent: View>(
        for routing: R.Type,
        @ViewBuilder content: @escaping (R.Pushable) -> PresentableContent
    ) -> some View {
        return modifier(PushableDestinationModifier(for: routing, pushableContent: content))
    }
}

/// See the `pushableDestination(for:content:)` modifier view extension.
public struct PushableDestinationModifier<R: Routing, PushableContent: View>: ViewModifier {

    private let pushableContent: (R.Pushable) -> PushableContent

    public init(
        for routing: R.Type,
        @ViewBuilder pushableContent: @escaping (R.Pushable) -> PushableContent
    ) {
        self.pushableContent = pushableContent
    }

    public func body(content: Content) -> some View {
        content
            .navigationDestination(for: R.Pushable.self) { pushable in
                pushableContent(pushable)
            }
    }
}
