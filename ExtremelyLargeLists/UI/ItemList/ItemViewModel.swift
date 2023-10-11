//  Created by Axel Ancona Esselmann on 10/10/23.
//

import SwiftUI
import Combine

@MainActor
class ItemViewModel: ObservableObject {

    private let store: any PersistentStore
    private let itemUpdateManager: ItemUpdateManager
    private let loadingManager: LoadingManager
    private var item: Item

    private var bag: AnyCancellable?

    init(item: Item, store: any PersistentStore, itemUpdateManager: ItemUpdateManager, loadingManager: LoadingManager) {
        self.item = itemUpdateManager.cached(forItemId: item.id) ?? item
        self.store = store
        self.itemUpdateManager = itemUpdateManager
        self.loadingManager = loadingManager
        bag = itemUpdateManager.itemHasUpdated
            .filter { $0.id == item.id }
            .sink { @MainActor [weak self] in
                self?.update(with: $0)
            }
    }

    var text: String {
        item.text
    }

    var id: Item.ID {
        item.id
    }

    var isSet: Bool {
        item.isSet
    }

    func toggle() async {
        loadingManager.isLoading = true
        let item = await store.toggled(item: item)
        itemUpdateManager.itemHasUpdated.send(item)
        loadingManager.isLoading = false
        objectWillChange.send()
    }

    func update(with newItem: Item) {
        item = newItem
        objectWillChange.send()
    }

    func remove() async {
        itemUpdateManager.itemWasRemoved.send(item)
    }
}

extension ItemViewModel {
    convenience init(item: Item) {
        self.init(
            item: item,
            store: AppState.shared.store,
            itemUpdateManager: AppState.shared.itemUpdateManager,
            loadingManager: AppState.shared.loadingManager
        )
    }
}
