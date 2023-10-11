//  Created by Axel Ancona Esselmann on 10/11/23.
//

import SwiftUI

struct TextFieldContainer: View {

    let title: String
    let onSubmit: (String) -> Void

    @State
    var text: String

    init(title: String? = nil, initialValue: String? = nil, onSubmit: @escaping (String) -> Void) {
        _text = State(initialValue: initialValue ?? "")
        self.onSubmit = onSubmit
        self.title = title ?? ""
    }

    init(title: String? = nil, initialValue: String? = nil, onSubmit: @escaping (String) async -> Void) {
        _text = State(initialValue: initialValue ?? "")
        self.onSubmit = { newValue in
            Task {
                await onSubmit(newValue)
            }
        }
        self.title = title ?? ""
    }

    var body: some View {
        HStack {
            TextField(title, text: $text)
                .onSubmit {
                    onSubmit(text)
                }
            Button("done") {
                onSubmit(text)
            }
        }
    }
}
