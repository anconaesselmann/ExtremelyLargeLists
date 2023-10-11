//  Created by Axel Ancona Esselmann on 10/11/23.
//

import SwiftUI

struct ToggleContainer: View {

    let initialValue: Bool
    let onToggle: (Bool) -> Void

    @State
    var value: Bool

    init(initialValue: Bool, onToggle: @escaping (Bool) -> Void) {
        self.initialValue = initialValue
        self.onToggle = onToggle
        _value = State(initialValue: initialValue)
    }

    init(initialValue: Bool, onToggle: @escaping (Bool) async -> Void) {
        self.initialValue = initialValue
        self.onToggle = { newValue in
            Task {
                await onToggle(newValue)
            }
        }
        _value = State(initialValue: initialValue)
    }

    var body: some View {
        Toggle("", isOn: Binding(
            get: {
                value
            }, set: {
                value = $0
                onToggle($0)
            }
        ))
    }
}
