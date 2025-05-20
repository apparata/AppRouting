//
//  Copyright © 2025 Apparata AB. All rights reserved.
//

import Swift

// MARK: - Routing Pushable

/// Represents a routing destination that can be pushed onto a navigation stack.
public protocol RoutingPushable: Identifiable, Hashable, Sendable, Codable {
    //
}

// MARK: - Default Implementations

public extension RoutingPushable {
    var id: Self { self }
}
