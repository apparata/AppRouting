//
//  Copyright © 2025 Apparata AB. All rights reserved.
//

import Swift

// MARK: - Routing Presentable

/// Represents a presentable routing destination, such as a sheet or full screen cover.
public protocol RoutingPresentable: Identifiable, Hashable, Sendable, Codable {
    //
}

// MARK: - Default Implementations

public extension RoutingPresentable {
    var id: Self { self }
}
