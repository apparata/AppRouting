//
//  Copyright © 2025 Apparata AB. All rights reserved.
//

import Swift

// MARK: - Routing

/// A base protocol defining routing behavior with associated types for different navigation destinations.
/// Conforming types must specify `Selectable`, `Pushable`, and `Presentable` types.
/// Each conforming type is meant to be associated with a router, `Router<T: Routing>`.
///
/// - Tab destinations should be represented by the `Selectable` type.
/// - Navigation stack destinations should be represented by the `Pushable` type.
/// - Sheet destinations should be represented by the `Presentable` type.
///
/// **Example:**
///
/// ```swift
/// public struct MainRouting: Routing {
///
///     public enum Selectable: RoutingSelectable {
///         case tabMap
///         case tabExplore
///         case tabCompare
///     }
///
///     public enum Pushable: RoutingPushable {
///         case detailsContinent(ContinentID)
///         case detailsCountry(CountryID)
///         case detailsCity(CityID)
///     }
///
///     public enum Presentable: RoutingPresentable {
///         case settings
///         case attributions
///         case profile(username: String)
///     }
/// }
/// ```
///
public protocol Routing: Sendable {

    /// Tab destinations should be represented by the `Selectable` type.
    associatedtype Selectable: RoutingSelectable

    /// Navigation stack destinations should be represented by the `Pushable` type.
    associatedtype Pushable: RoutingPushable

    /// Sheet destinations should be represented by the `Presentable` type.
    associatedtype Presentable: RoutingPresentable
}

// MARK: - Selectable and Pushable

/// A protocol for routing that supports selection and pushing, but not presentation.
///
/// **Example:**
///
/// ```swift
/// public struct MainRouting: SelectablePushableRouting {
///
///     public enum Selectable: RoutingSelectable {
///         case tabMap
///         case tabExplore
///         case tabCompare
///     }
///
///     public enum Pushable: RoutingPushable {
///         case detailsContinent(ContinentID)
///         case detailsCountry(CountryID)
///         case detailsCity(CityID)
///     }
/// }
/// ```
///
public protocol SelectablePushableRouting: Routing where Presentable == NoPresentable {
    //
}

// MARK: - Selectable and Presentable

/// A protocol for routing that supports selection and presentation, but not pushing.
///
/// **Example:**
///
/// ```swift
/// public struct MainRouting: SelectablePresentableRouting {
///
///     public enum Selectable: RoutingSelectable {
///         case tabMap
///         case tabExplore
///         case tabCompare
///     }
///
///     public enum Presentable: RoutingPresentable {
///         case settings
///         case attributions
///         case profile(username: String)
///     }
/// }
/// ```
///
public protocol SelectablePresentableRouting: Routing where Pushable == NoPushable {
    //
}

// MARK: - Pushable and Presentable

/// A protocol for routing that supports pushing and presentation, but not selection.
///
/// **Example:**
///
/// ```swift
/// public struct MainRouting: PushablePresentableRouting {
///
///     public enum Pushable: RoutingPushable {
///         case detailsContinent(ContinentID)
///         case detailsCountry(CountryID)
///         case detailsCity(CityID)
///     }
///
///     public enum Presentable: RoutingPresentable {
///         case settings
///         case attributions
///         case profile(username: String)
///     }
/// }
/// ```
///
public protocol PushablePresentableRouting: Routing where Selectable == NoSelectable {
    //
}

// MARK: - Only Selectable

/// A protocol for routing that only supports selection.
///
/// **Example:**
///
/// ```swift
/// public struct MainRouting: SelectableRouting {
///
///     public enum Selectable: RoutingSelectable {
///         case tabMap
///         case tabExplore
///         case tabCompare
///     }
/// }
/// ```
///
public protocol SelectableRouting: Routing where Pushable == NoPushable, Presentable == NoPresentable {
    //
}

// MARK: - Only Pushable

/// A protocol for routing that only supports pushing.
///
/// **Example:**
///
/// ```swift
/// public struct MainRouting: PushableRouting {
///
///     public enum Pushable: RoutingPushable {
///         case detailsContinent(ContinentID)
///         case detailsCountry(CountryID)
///         case detailsCity(CityID)
///     }
/// }
/// ```
///
public protocol PushableRouting: Routing where Selectable == NoSelectable, Presentable == NoPresentable {
    //
}

// MARK: - Only Presentable

/// A protocol for routing that only supports presentation.
///
/// **Example:**
///
/// ```swift
/// public struct MainRouting: PresentingRouting {
///
///     public enum Presentable: RoutingPresentable {
///         case settings
///         case attributions
///         case profile(username: String)
///     }
/// }
/// ```
///
public protocol PresentableRouting: Routing where Selectable == NoSelectable, Pushable == NoPushable {
    //
}

// MARK: - No Selectable

/// A type for conveniently specifying that there are no selectable tab destinations.
///
/// This will probably not be used directly by clients of this package.
///
public struct NoSelectable: RoutingSelectable {
    public static let allCases = [Self()]
}

// MARK: - No Pushable

/// A type for conveniently specifying that there are no pushable navigation stack destinations.
///
/// This will probably not be used directly by clients of this package.
///
public struct NoPushable: RoutingPushable {
    //
}

// MARK: - No Presentable

/// A type for conveniently specifying that there are not presentable sheet destinations.
///
/// This will probably not be used directly by clients of this package.
///
public struct NoPresentable: RoutingPresentable {
    //
}
