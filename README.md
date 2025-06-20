
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

    public enum Selectable: SelectableDestination {
        case tabMap
        case tabExplore
        case tabCompare
    }

    public enum Pushable: PushableDestination {
        case detailsContinent(ContinentID)
        case detailsCountry(CountryID)
        case detailsCity(CityID)
    }

    public enum Presentable: PresentableDestination {
        case settings
        case attributions
        case profile(username: String)
    }
}
```

### Meta Routing

⚠️ Documentation pending.

A wrapper around ``Router`` that uses a builder-like interface for switching routing context. Allows navigation within a routing context while enabling access to other routing types.

## Deep Links

⚠️ Documentation pending

The AppRouting package plays well together with the deep link matching from the [URLToolbox](https://github.com/apparata/URLToolbox) package.
