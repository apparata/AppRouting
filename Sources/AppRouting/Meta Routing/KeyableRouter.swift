//
//  Copyright © 2025 Apparata AB. All rights reserved.
//

import SwiftUI

/// A protocol indicating that a conforming type can provide a unique key identifying the router.
/// Used to distinguish between different routing configurations by the `MetaRouter`.
@MainActor public protocol KeyableRouter {

    /// A unique key representing the type of routing.
    var routingTypeKey: RoutingTypeKey { get }
}

extension Router: KeyableRouter {
    /// Provides a unique key based on the type of routing used by the router.
    public var routingTypeKey: RoutingTypeKey {
        RoutingTypeKey(T.self)
    }
}

/// A hashable key used to uniquely identify routing instances.
/// Used to distinguish between different routing configurations by the `MetaRouter`.
public struct RoutingTypeKey: Hashable {

    private let routingType: String

    /// Initializes a new `RoutingTypeKey` with a type conforming to `Routing`.
    /// - Parameter routingType: The routing type used to generate the key.
    init<T: Routing>(_ routingType: T.Type) {
        self.routingType = String(reflecting: routingType)
    }

    /// Hashes the essential components of the routing type key.
    /// - Parameter hasher: The hasher to use when combining the components.
    public func hash(into hasher: inout Hasher) {
        hasher.combine(routingType)
    }

    /// Compares two `RoutingTypeKey` instances for equality.
    /// - Parameters:
    ///   - lhs: The left-hand side key.
    ///   - rhs: The right-hand side key.
    /// - Returns: A Boolean value indicating whether the two keys are equal.
    public static func == (lhs: RoutingTypeKey, rhs: RoutingTypeKey) -> Bool {
        return lhs.routingType == rhs.routingType
    }
}
