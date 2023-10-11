//  Created by Axel Ancona Esselmann on 10/10/23.
//

import SwiftUI
import DebugSwiftUI

struct ItemList: View {

    // Have as few as possible State/StateObject/EnvironmentObjects as possible since a change to either of them will redraw the View
    @StateObject
    var vm = ItemListViewModel()

    var body: some View {
        ZStack {
            VStack {
                DebugView(self)
                HStack {
                    Button("sort", action: vm.sort)
                    Button("toggle marked", action: vm.toggle)
                    Button("Add new", action: vm.addNew)
                    Button("-", action: vm.remove)
                }
                List(selection: $vm.selection) {
                    ForEach(vm.items) {
                        ItemView(item: $0)
//                            .id($0.id) // Note: Adding an id to the cell for large lists will break the app
                    }
                }.id(vm.listId) // New list for large lists whenever the view model updates (this won't animate changes but is super fast)
                Text("Number of entries: \(vm.items.count)")
                    .padding()
            }
            LoadingView()
        }.task {
            await vm.onAppear()
        }
        // avoid onChange if possible and have the view model react to changes using publishers and Combine to make sure we can compute the entire change before we acctually update the UI
    }
}
