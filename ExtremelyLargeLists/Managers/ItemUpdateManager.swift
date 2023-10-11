//  Created by Axel Ancona Esselmann on 10/10/23.
//

import SwiftUI
import Combine

@MainActor
class ItemUpdateManager {
    var itemHasUpdated = PassthroughSubject<Item, Never>()
    var itemWasRemoved = PassthroughSubject<Item, Never>()

    var bag = Set<AnyCancellable>()

    // I really don't want to have to update the list view's array (which would be O(n).)
    // Downside: The list view WILL be out of date until it is refreshed.
    private var cached: [Item.ID: Item] = [:]

    init() {
        itemHasUpdated.sink { [weak self] item in
            self?.cache(item)
        }.store(in: &bag)

        itemWasRemoved.sink { [weak self] item in
            self?.removeFromCache(item)
        }.store(in: &bag)
    }

    @MainActor
    private func cache(_ item: Item) {
        cached[item.id] = item
    }

    @MainActor
    private func removeFromCache(_ item: Item) {
        cached[item.id] = nil
    }

    @MainActor
    func cached(forItemId id: Item.ID) -> Item? {
        cached[id]
    }

    @MainActor
    func clearCache() {
        cached = [:]
    }
}
