//
//  Copyright © 2025 Apparata AB. All rights reserved.
//

import Swift
import OSLog

// MARK: - SelectableDestination

/// Represents a routing destination that is selectable, such as a tab.
public protocol SelectableDestination: Identifiable, Hashable, CaseIterable, Sendable, Codable {

    /// The selectable that should be active by default.
    /// The default implementation will take the first element from `allCases`.
    static var defaultActive: Self { get }
}

// MARK: - Default Implementations

public extension SelectableDestination {
    var id: Self { self }

    static var defaultActive: Self {
        guard let selectable = allCases.first else {
            Logger.appRouting.error("No selectable available.")
            fatalError("No selectable available.")
        }
        return selectable
    }
}
