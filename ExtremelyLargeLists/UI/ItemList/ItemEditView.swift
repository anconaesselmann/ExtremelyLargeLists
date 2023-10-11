//  Created by Axel Ancona Esselmann on 10/11/23.
//

import SwiftUI
import DebugSwiftUI

struct ItemEditView: View, Identifiable {
    let id: Item.ID

    @StateObject
    var vm: ItemEditViewModel

    init(id: Item.ID) {
        self.id = id
        _vm = StateObject(wrappedValue: ItemEditViewModel(id: id))
    }

    var body: some View {
        VStack {
            DebugView(self)
            ZStack {
                VStack {
                    if let item = vm.item {
                        TextFieldContainer(initialValue: item.text, onSubmit: vm.updateText)
                        HStack {
                            Text("Is set:")
                            ToggleContainer(initialValue: item.isSet, onToggle: vm.updateIsSet)
                            Spacer()
                        }
                    }
                    Spacer()
                }
                .padding()
                LoadingView()
            }.task {
                await vm.onAppear()
            }
        }
        .id(vm.refreshId) // The VM detect outside changes and will promet the UI to redraw. Internal changes do not need to trigger a redraw since individual components handle state changes
    }
}
