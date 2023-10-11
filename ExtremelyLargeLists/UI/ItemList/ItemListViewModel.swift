//  Created by Axel Ancona Esselmann on 10/10/23.
//

import SwiftUI
import LoremSwiftum
import Combine

// ViewModels should be MainActors. Managers acting on none-view data should be global actors. Managers that manage view state can be Main Actors (loading manager)
@MainActor
class ItemListViewModel: ObservableObject {

    private let store: any PersistentStore
    private let loadingManager: LoadingManager
    private let itemUpdateManager: ItemUpdateManager
    private let splitViewManager: SplitViewManager

    // When possible manage publishing of state change manually. That way we can avoid re-drawing the UI with interim view states
    private var ascending: Bool = true

    private var hasLoadedOnAppear: Bool = false

    // Expose as few properties as possible since the entire view will be re-drawn when properties update. Create self-contained subviews instead; those will be redrawn only if their state updates. (Example: Loading is handled by a subview with self-contained state to allow scrolling the list while the list gets re-fetched and processed on a background thread with a global actor)
    // Note: Using the ItemUpdateManager items WILL become stale. Use core data to process items
    var items: [Item] = []

    var selection: Item.ID? {
        didSet {
            if let selection = selection {
                splitViewManager.layout = .all(selection)
            } else {
                splitViewManager.layout = .onlyLeft
            }
        }
    }

    private var smallListId = UUID()

    var listId: UUID {
        if items.count < 100 {
            return smallListId
        } else {
            return UUID()
        }
    }

    private var bag: AnyCancellable?

    // Instead of relying on environment objects we inject properties from the app state singleton. This allows for mocking and we have access to the proeprties in our initializer (environment objects become available after the view has appeared and accessing them before causes a crash)
    init(
        store: any PersistentStore,
        loadingManager: LoadingManager,
        itemUpdateManager: ItemUpdateManager,
        splitViewManager: SplitViewManager
    ) {
        self.store = store
        self.loadingManager = loadingManager
        self.itemUpdateManager = itemUpdateManager
        self.splitViewManager = splitViewManager
        bag = itemUpdateManager.itemWasRemoved.sink { item in
            Task { [weak self] in
                await self?.remove(item: item)
            }
        }
    }

    func onAppear() async {
        guard !hasLoadedOnAppear else {
            return
        }
        loadingManager.isLoading = true
        items = await store.fetchAll(ascending: ascending)
        itemUpdateManager.clearCache()
        loadingManager.isLoading = false
        hasLoadedOnAppear = true
        objectWillChange.send()
    }

    func sort() async {
        loadingManager.isLoading = true
        ascending.toggle()
        // Use core data to do sorting and processing as much as possible since it is much faster for large data sets. BUT: Tables allow sort comparitors. Those are faster.
        items = await store.fetchAll(ascending: ascending)
        itemUpdateManager.clearCache()
        loadingManager.isLoading = false
        objectWillChange.send()
    }

    func toggle() async {
        // To avoid reloading the list we update the store, the items array and the individual list cells (with the items update manager). This way we presever the list scroll state
        guard !items.isEmpty else {
            return
        }
        let to = min(items.count, 10)
        loadingManager.isLoading = true
        for index in 0..<to {
            let item = items[index]
            let toggled = await store.toggled(item: item)
            items[index] = toggled
            itemUpdateManager.itemHasUpdated.send(toggled)
        }
        loadingManager.isLoading = false
    }

    func addNew() async {
        loadingManager.isLoading = true
        let new = Item(text: Lorem.fullName, isSet: false)
        await store.create(item: new)
        items.insert(new, at: 0)
        loadingManager.isLoading = false
        objectWillChange.send()
    }

    func remove() async {
        guard !items.isEmpty else {
            return
        }
        let item: Item = items.remove(at: 0)
        loadingManager.isLoading = true
        do {
            try await store.remove(itemWithId: item.id)
            objectWillChange.send()
        } catch {
            print(error)
        }
        loadingManager.isLoading = false
    }

    func remove(item: Item) async {
        guard let index = items.firstIndex(where: { item.id == $0.id} ) else {
            return
        }
        let item: Item = items.remove(at: index)
        loadingManager.isLoading = true
        do {
            try await store.remove(itemWithId: item.id)
            objectWillChange.send()
        } catch {
            print(error)
        }
        loadingManager.isLoading = false
    }
}

// Only view models are allowed access to the AppState shared property
extension ItemListViewModel {
    convenience init() {
        self.init(
            store: AppState.shared.store, 
            loadingManager: AppState.shared.loadingManager,
            itemUpdateManager: AppState.shared.itemUpdateManager,
            splitViewManager: AppState.shared.splitViewManager
        )
    }
}
