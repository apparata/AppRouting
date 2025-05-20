
# AppRouting

An implementation of view routing for SwiftUI.

## License

See the LICENSE file for licensing information.

## Usage

⚠️ Documentation pending.

### Routing

⚠️ Documentation pending.

A base protocol defining routing behavior with associated types for different navigation destinations. Conforming types must specify `Selectable`, `Pushable`, and `Presentable` types. Each conforming type is meant to be associated with a router, `Router<T: Routing>`.

- Tab destinations should be represented by the `Selectable` type.
- Navigation stack destinations should be represented by the `Pushable` type.
- Sheet destinations should be represented by the `Presentable` type.

**Example:**

```swift
public struct MainRouting: Routing {

    public enum Selectable: RoutingSelectable {
        case tabMap
        case tabExplore
        case tabCompare
    }

    public enum Pushable: RoutingPushable {
        case detailsContinent(ContinentID)
        case detailsCountry(CountryID)
        case detailsCity(CityID)
    }

    public enum Presentable: RoutingPresentable {
        case settings
        case attributions
        case profile(username: String)
    }
}
```

### Meta Routing

⚠️ Documentation pending.

A wrapper around ``Router`` that uses a builder-like interface for switching routing context. Allows navigation within a routing context while enabling access to other routing types.

## Convenience Buttons

### Routing Button

Convenience button that wraps an `@Environment` for providing the router instance, corresponding to the given `Routing`, to the action closure.

**Example:**

Let's assume that this button is already part of the product list tab.

```swift
RoutingButton(MainRouting.self) { router in
    router.push(.productDetails(productID: "12532"))
} label: {
    Text("Details")
}
.buttonStyle(.borderedProminent)
```

If the button is somewhere else, and we want to make sure the correct tab is selected first, we can chain the routing functions.

```swift
RoutingButton(MainRouting.self) { router in
    router
        .select(.productsTab)
        .push(.productDetails(productID: "12532"))
} label: {
    Text("Details")
}
.buttonStyle(.borderedProminent)
```

### MetaRoutingButton

Convenience button that wraps an `@Environment` for providing the `MetaRouter` instance, corresponding to the given root `Routing`, to the action closure.

**Example:**

```swift
MetaRoutingButton(MainRouting.self) { metaRouting in
    metaRouting
        .select(.profileTab)
        .presentSheet(.settings)
        .routing(SettingsRouting.self)
        .dismissPresentables()
        .push(.attributions)
} label: {
    Text("Attributions")
}
.buttonStyle(.borderedProminent)
```

## Deep Links

⚠️ Documentation pending

The AppRouting package plays well together with the deep link matching from the [URLToolbox](https://github.com/apparata/URLToolbox) package.
