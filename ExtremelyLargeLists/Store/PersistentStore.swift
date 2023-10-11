//  Created by Axel Ancona Esselmann on 10/10/23.
//

import Foundation

protocol PersistentStore: Actor, ObservableObject {
    func fetchAll(ascending: Bool) -> [Item]
    func toggled(item: Item) -> Item
    func create(item: Item)
    func fetch(itemWithId id: Item.ID) -> Item?
    func remove(itemWithId id: Item.ID) throws

    func update(itemWithId id: Item.ID, newText: String) -> Item?
    func update(itemWithId id: Item.ID, isSet: Bool) -> Item?
}
