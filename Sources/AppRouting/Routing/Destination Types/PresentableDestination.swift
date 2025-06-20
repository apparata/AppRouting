//
//  Copyright © 2025 Apparata AB. All rights reserved.
//

import Swift

// MARK: - Presentable Destination

/// Represents a presentable routing destination, such as a sheet or full screen cover.
public protocol PresentableDestination: Identifiable, Hashable, Sendable, Codable {
    //
}

// MARK: - Default Implementations

public extension PresentableDestination {
    var id: Self { self }
}
