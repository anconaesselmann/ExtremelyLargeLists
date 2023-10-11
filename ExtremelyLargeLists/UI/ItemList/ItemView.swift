//  Created by Axel Ancona Esselmann on 10/10/23.
//

import SwiftUI
import DebugSwiftUI

struct ItemView: View, Identifiable {

    let id: Item.ID

    @StateObject
    var vm: ItemViewModel

    init(item: Item) {
        id = item.id
        _vm = StateObject(wrappedValue: ItemViewModel(item: item))
    }

    var body: some View {
        HStack {
            Text(vm.text)
            Button(vm.isSet ? "set" : "not set", action: vm.toggle)
                .buttonStyle(.bordered)
            Button("-", action: vm.remove)
                .buttonStyle(.bordered)
            DebugView(self)
        }
    }
}
