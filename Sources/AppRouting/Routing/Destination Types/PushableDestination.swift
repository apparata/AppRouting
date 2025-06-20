//
//  Copyright © 2025 Apparata AB. All rights reserved.
//

import Swift

// MARK: - Pushable Destination

/// Represents a routing destination that can be pushed onto a navigation stack.
public protocol PushableDestination: Identifiable, Hashable, Sendable, Codable {
    //
}

// MARK: - Default Implementations

public extension PushableDestination {
    var id: Self { self }
}
