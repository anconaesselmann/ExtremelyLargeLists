//  Created by Axel Ancona Esselmann on 10/11/23.
//

import SwiftUI
import Combine

@MainActor
class ItemEditViewModel: ObservableObject {

    private let store: any PersistentStore
    private let loadingManager: LoadingManager
    private let itemUpdateManager: ItemUpdateManager
    private let splitViewManager: SplitViewManager

    let id: Item.ID

    var item: Item?

    var bag = Set<AnyCancellable>()

    var refreshId: UUID = UUID()

    init(
        id: Item.ID,
        loadingManager: LoadingManager,
        store: any PersistentStore,
        itemUpdateManager: ItemUpdateManager,
        splitViewManager: SplitViewManager
    ) {
        self.id = id
        self.store = store
        self.loadingManager = loadingManager
        self.itemUpdateManager = itemUpdateManager
        self.splitViewManager = splitViewManager

        itemUpdateManager.itemHasUpdated
            .filter { $0.id == id }
            .sink { [weak self] newItem in
                self?.update(with: newItem)
            }
            .store(in: &bag)
        itemUpdateManager.itemWasRemoved
            .filter { $0.id == id }
            .sink { [weak self] newItem in
                self?.itemWasRemoved()
            }
            .store(in: &bag)
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
        guard newValue != item?.text else {
            return
        }
        loadingManager.isLoading = true
        if let item = await store.update(itemWithId: id, newText: newValue) {
            itemUpdateManager.itemHasUpdated.send(item)
        }
        loadingManager.isLoading = false
    }

    func updateIsSet(_ newValue: Bool) async {
        guard newValue != item?.isSet else {
            return
        }
        loadingManager.isLoading = true
        if let item = await store.update(itemWithId: id, isSet: newValue) {
            itemUpdateManager.itemHasUpdated.send(item)
        }
        loadingManager.isLoading = false
    }

    private func update(with newItem: Item) {
        guard newItem != item else {
            return
        }
        item = newItem
        refreshId = UUID()
        objectWillChange.send()
    }

    private func itemWasRemoved() {
        splitViewManager.layout = .onlyLeft
    }
}

extension ItemEditViewModel {
    convenience init(id: Item.ID) {
        self.init(
            id: id,
            loadingManager: AppState.shared.loadingManager,
            store: AppState.shared.store,
            itemUpdateManager: AppState.shared.itemUpdateManager,
            splitViewManager: AppState.shared.splitViewManager
        )
    }
}
