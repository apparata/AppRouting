//
//  Copyright © 2025 Apparata AB. All rights reserved.
//

import SwiftUI

public struct RoutingButton<R: Routing, Label: View>: View {

    @Environment(Router<R>.self) private var router

    private let action: (Router<R>) -> Void
    private let label: Label

    @preconcurrency public init(
        _ routing: R.Type,
        action: @escaping @MainActor (Router<R>) -> Void,
        @ViewBuilder label: () -> Label
    ) {
        self.action = action
        self.label = label()
    }

    public var body: some View {
        Button {
            action(router)
        } label: {
            label
        }
    }
}
