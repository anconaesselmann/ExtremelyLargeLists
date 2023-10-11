//  Created by Axel Ancona Esselmann on 10/11/23.
//

import SwiftUI
import Combine

@MainActor
class ItemEditViewModel: ObservableObject {

    private let store: any PersistentStore
    private let loadingManager: LoadingManager
    private let itemUpdateManager: ItemUpdateManager

    let id: Item.ID

    var item: Item?

    var bag: AnyCancellable?

    init(
        id: Item.ID,
        loadingManager: LoadingManager,
        store: any PersistentStore,
        itemUpdateManager: ItemUpdateManager
    ) {
        self.id = id
        self.store = store
        self.loadingManager = loadingManager
        self.itemUpdateManager = itemUpdateManager
    }

    func onAppear() async {
        guard item?.id != id else {
            return
        }
        loadingManager.isLoading = true
        item = await store.fetch(itemWithId: id)
        objectWillChange.send()
        loadingManager.isLoading = false
    }

    func updateText(_ newValue: String) async {
        loadingManager.isLoading = true
        if let item = await store.update(itemWithId: id, newText: newValue) {
            itemUpdateManager.itemHasUpdated.send(item)
        }
        loadingManager.isLoading = false
    }

    func updateIsSet(_ newValue: Bool) async {
        loadingManager.isLoading = true
        if let item = await store.update(itemWithId: id, isSet: newValue) {
            itemUpdateManager.itemHasUpdated.send(item)
        }
        loadingManager.isLoading = false
    }
}

extension ItemEditViewModel {
    convenience init(id: Item.ID) {
        self.init(
            id: id,
            loadingManager: AppState.shared.loadingManager,
            store: AppState.shared.store,
            itemUpdateManager: AppState.shared.itemUpdateManager
        )
    }
}
