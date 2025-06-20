//
//  Copyright © 2025 Apparata AB. All rights reserved.
//

import SwiftUI

// MARK: - Routing Node

/// Routing tree context node containing a router and optional child contexts.
@MainActor public struct RoutingContext {

    /// The type key identifying the routing type of this context node.
    public let type: RoutingTypeKey

    /// The child nodes of this routing context node.
    public let children: [RoutingContext]

    /// The router associated with this routing context node.
    public let router: any KeyableRouter

    /// Initializes a routing context node with a type and optional children.
    public init<T: Routing>(_ type: T.Type, children: [RoutingContext] = []) {
        self.type = RoutingTypeKey(type)
        self.children = children
        self.router = Router<T>()
    }

    /// Initializes a routing context node using a result builder to define its children.
    public init<T: Routing>(_ type: T.Type, @RoutingContextsBuilder children: () -> [RoutingContext]) {
        self.type = RoutingTypeKey(type)
        self.children = children()
        self.router = Router<T>()
    }
}

// MARK: - Routing Nodes Builder

/// A result builder for constructing arrays of `RoutingContext` instances.
@resultBuilder @MainActor public struct RoutingContextsBuilder {

    public static func buildBlock() -> [RoutingContext] {
        return []
    }

    public static func buildBlock(_ expression: RoutingContext) -> [RoutingContext] {
        return [expression]
    }

    public static func buildBlock(_ components: RoutingContext...) -> [RoutingContext] {
        return components
    }

    public static func buildPartialBlock(first: RoutingContext) -> [RoutingContext] {
        return [first]
    }

    public static func buildPartialBlock(first: [RoutingContext]) -> [RoutingContext] {
        return first
    }

    public static func buildPartialBlock(accumulated: [RoutingContext], next: RoutingContext) -> [RoutingContext] {
        return accumulated + [next]
    }

    public static func buildPartialBlock(accumulated: [RoutingContext], next: [RoutingContext]) -> [RoutingContext] {
        return accumulated + next
    }

    public static func buildExpression(_ expression: RoutingContext) -> [RoutingContext] {
        return [expression]
    }

    public static func buildExpression<T: Routing>(_ expression: T.Type) -> [RoutingContext] {
        return [RoutingContext(expression)]
    }

    public static func buildArray(_ components: [[RoutingContext]]) -> [RoutingContext] {
        return components.flatMap { $0 }
    }
}

// MARK: - Context Children Operator

infix operator -->: MultiplicationPrecedence
@MainActor public func --> <T: Routing>(lhs: T.Type, @RoutingContextsBuilder rhs: () -> [RoutingContext]) -> RoutingContext {
    return RoutingContext(lhs, children: rhs())
}
