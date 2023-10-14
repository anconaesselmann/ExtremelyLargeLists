//  Created by Axel Ancona Esselmann on 10/10/23.
//

import Foundation
import CoreData
import LoremSwiftum
import CoreDataStored

@globalActor
actor DataController: ObservableObject, PersistentStore {
    let container = NSPersistentContainer(name: "Items")

    static let shared = DataController()

    init() { }

    lazy var itemBackgroundContext: NSManagedObjectContext = {
        container.newBackgroundContext()
    }()

    func initialize() async throws {
        try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<Void, Error>) in
            container.loadPersistentStores { description, error in
                if let error = error {
                    print("Core Data failed to load: \(error.localizedDescription)")
                    continuation.resume(throwing: CoreDataError.couldNotLoadStore)
                } else {
                    continuation.resume()
                }
            }
            print(container.persistentStoreDescriptions)
        }
    }

    func fetchAll(ascending: Bool) -> [Item] {
        (try? Item.fetchAll(in: itemBackgroundContext, sortedBy: \.text, ascending: ascending)) ?? []
    }

    func toggled(item: Item) -> Item {
        (try? Item.toggle(\.isSet, itemWithId: item.id, in: itemBackgroundContext)) ?? item
    }

    func create(item: Item) {
        let _ = try? item.entity(in: itemBackgroundContext, save: true)
    }

    func fetch(itemWithId id: Item.ID) -> Item? {
        try? Item(id: id, in: itemBackgroundContext)
    }

    func remove(itemWithId id: Item.ID) throws {
        try Item.delete(id: id, in: itemBackgroundContext)
    }

    func update(itemWithId id: Item.ID, newText: String) -> Item? {
        try? Item.update(
            itemWithId: id,
            in: itemBackgroundContext,
            set: \.text,
            to: newText
        )
    }

    func update(itemWithId id: Item.ID, isSet: Bool) -> Item? {
        try? Item.update(
            itemWithId: id,
            in: itemBackgroundContext,
            set: \.isSet,
            to: isSet
        )
    }
}
