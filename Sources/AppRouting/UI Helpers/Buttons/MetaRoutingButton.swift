//
//  Copyright © 2025 Apparata AB. All rights reserved.
//

import SwiftUI

public struct MetaRoutingButton<R: Routing, Label: View>: View {

    @Environment(MetaRouter.self) private var metaRouter

    private let routing: R.Type
    private let action: (MetaRouting<R>) -> Void
    private let label: Label

    @preconcurrency public init(
        _ routing: R.Type,
        action: @escaping @MainActor (MetaRouting<R>) -> Void,
        @ViewBuilder label: () -> Label
    ) {
        self.routing = routing
        self.action = action
        self.label = label()
    }

    public var body: some View {
        Button {
            action(metaRouter.routing(routing))
        } label: {
            label
        }
    }
}
