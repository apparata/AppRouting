//
//  Copyright © 2025 Apparata AB. All rights reserved.
//

import SwiftUI

/// A generic router class that manages navigation state for a given routing configuration.
/// Handles tab selection, navigation stack, and modal presentations.
///
/// A router object can at most select one tab, have one navigation path and can present one sheet.
/// If e.g. a sheet is presented, it needs a new router for its context. To navigate between contexts
/// programmatically, use a ``MetaRouter``.
///
@Observable @MainActor public class Router<T: Routing>: @preconcurrency Codable {

    /// The currently selected tab or main navigation destination.
    public var activeSelectable: T.Selectable

    /// A dictionary mapping each selectable to its corresponding navigation stack.
    /// Essentially, this is the navigation stack for each tab.
    ///
    /// - Note: Do NOT modify this property manually. It's only meant for bindings.
    ///
    public var paths: [T.Selectable: [T.Pushable]] = {
        T.Selectable.allCases.reduce(into: [:]) { result, selectable in
            result[selectable] = []
        }
    }()

    /// The navigation stack for the currently selected tab.
    public var activePath: [T.Pushable] {
        get {
            // swiftlint:disable:next force_unwrapping
            return paths[activeSelectable]!
        }
        set {
            paths[activeSelectable] = newValue
        }
    }

    /// The currently presented sheet destination.
    /// Setting this will also dismiss any full-screen cover.
    public var presentedSheet: T.Presentable? {
        willSet {
            if presentedFullScreenCover != nil {
                presentedFullScreenCover = nil
            }
        }
    }

    /// The currently presented full-screen cover destination.
    /// Setting this will also dismiss any presented sheet.
    public var presentedFullScreenCover: T.Presentable? {
        willSet {
            if presentedSheet != nil {
                presentedSheet = nil
            }
        }
    }

    /// Initializes the router with an optional initial tab. Defaults to the default active tab if not specified.
    ///
    /// - Parameter activeSelectable: The tab to set as initially active.
    ///
    public init(active activeSelectable: T.Selectable? = nil) {

        self.activeSelectable = activeSelectable ?? T.Selectable.defaultActive

        // Set up empty paths
        paths = T.Selectable.allCases.reduce(into: [:]) { result, selectable in
            result[selectable] = []
        }
    }

    // MARK: Subscript Selectable to Path

    /// Access or update the navigation path for a specific selectable.
    public subscript(_ selectable: T.Selectable) -> [T.Pushable] {
        get {
            paths[selectable] ?? []
        }
        set {
            paths[selectable] = newValue
        }
    }

    // MARK: Select Tab

    /// Selects a tab or navigation root.
    ///
    /// - Parameter selectable: The tab or navigation root to select.
    /// - Returns: The router instance for method chaining.
    ///
    @discardableResult public func select(_ selectable: T.Selectable) -> Router<T> {
        activeSelectable = selectable
        return self
    }

    // MARK: Set Path

    /// Pushes one or more destinations onto the root of the navigation stack
    /// (of the currently active selectable).
    ///
    /// - Parameter pushable: One or more destinations to push from the root of the stack.
    /// - Returns: The router instance for method chaining.
    ///
    @discardableResult public func setPath(_ pushable: T.Pushable...) -> Router<T> {
        activePath.append(contentsOf: pushable)
        return self
    }

    /// Pushes one or more destinations onto the root of the navigation stack
    /// (of the currently active selectable).
    ///
    /// - Parameter pushable: Array of destinations to push from the root of the stack.
    /// - Returns: The router instance for method chaining.
    ///
    @discardableResult public func setPath(_ pushables: [T.Pushable]) -> Router<T> {
        activePath.append(contentsOf: pushables)
        return self
    }

    // MARK: Push

    /// Pushes one or more destinations onto the navigation stack (of the currently active selectable).
    ///
    /// - Parameter pushable: One or more destinations to push.
    /// - Returns: The router instance for method chaining.
    ///
    @discardableResult public func push(_ pushable: T.Pushable...) -> Router<T> {
        activePath.append(contentsOf: pushable)
        return self
    }

    /// Pushes one or more destinations onto the navigation stack (of the currently active selectable).
    ///
    /// - Parameter pushables: Array of pushable destinations to push.
    /// - Returns: The router instance for method chaining.
    ///
    @discardableResult public func push(_ pushables: [T.Pushable]) -> Router<T> {
        activePath.append(contentsOf: pushables)
        return self
    }

    // MARK: Pop

    /// Pops the top destination from the navigation stack (of the currently active selectable).
    ///
    /// - Returns: The router instance for method chaining.
    ///
    @discardableResult public func pop() -> Router<T> {
        activePath.removeLast()
        return self
    }

    // MARK: Pop Multiple Levels

    /// Pops the specified number of destinations from the navigation stack.
    ///
    /// - Parameter levels: The number of levels to pop. If greater than the stack size, the stack will be emptied.
    /// - Returns: The router instance for method chaining.
    ///
    @discardableResult public func pop(levels: Int) -> Router<T> {
        let count = max(min(levels, activePath.count), 0)
        activePath.removeLast(count)
        return self
    }

    // MARK: Pop to Root

    /// Pops all destinations, returning the navigation stack to its root state.
    ///
    /// - Returns: The router instance for method chaining.
    ///
    @discardableResult public func popToRoot() -> Router<T> {
        activePath = []
        return self
    }

    // MARK: Present Sheet

    /// Presents a sheet with the given destination.
    ///
    /// - Parameter presentable: The destination to present as a sheet.
    ///
    @discardableResult public func presentSheet(_ presentable: T.Presentable) -> Router<T> {
        presentedSheet = presentable
        return self
    }

    // MARK: Present Full Screen Cover

    /// Presents a full-screen cover with the given destination.
    ///
    /// - Parameter presentable: The destination to present as a full-screen cover.
    ///
    @discardableResult public func presentFullScreenCover(_ presentable: T.Presentable) -> Router<T> {
        presentedFullScreenCover = presentable
        return self
    }

    // MARK: Dismiss Presented

    /// Dismisses any presented sheet or full-screen cover.
    @discardableResult public func dismiss() -> Router<T> {
        if presentedSheet != nil {
            presentedSheet = nil
        }
        if presentedFullScreenCover != nil {
            presentedFullScreenCover = nil
        }
        return self
    }

    // MARK: - Codable Compliance

    /// Coding keys for encoding and decoding router state.
    enum CodingKeys: String, CodingKey {
        case activeSelectable
        case paths
        case presentedSheet
        case presentedFullScreenCover
    }

    /// Decodes the router's state from the given decoder.
    required public init(from decoder: Decoder) throws {
        let data = try decoder.container(keyedBy: CodingKeys.self)
        self.activeSelectable = try data.decode(T.Selectable.self, forKey: .activeSelectable)
        self.paths = try data.decode([T.Selectable: [T.Pushable]].self, forKey: .paths)
        self.presentedSheet = try data.decodeIfPresent(T.Presentable.self, forKey: .presentedSheet)
        self.presentedFullScreenCover = try data.decodeIfPresent(T.Presentable.self, forKey: .presentedFullScreenCover)
    }

    /// Encodes the router's current state into the given encoder.
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(activeSelectable, forKey: .activeSelectable)
        try container.encode(paths, forKey: .paths)
        try container.encodeIfPresent(presentedSheet, forKey: .presentedSheet)
        try container.encodeIfPresent(presentedFullScreenCover, forKey: .presentedFullScreenCover)
    }
}
