//  Created by Axel Ancona Esselmann on 10/10/23.
//

import Foundation
import CoreData
import LoremSwiftum

enum CoreDataError: Error {
    case couldNotLoadStore
    case noElementWithId(Item.ID)
}

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
        let context = itemBackgroundContext
        let request = ItemEntity.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: #keyPath(ItemEntity.text), ascending: ascending)]
        do {
            let items = try context.fetch(request)
            return items.compactMap(Item.init)
        } catch {
            return []
        }
    }

    func toggled(item: Item) -> Item {
        let context = itemBackgroundContext
        let request = ItemEntity.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", item.id as CVarArg)
        request.fetchLimit = 1
        do {
            let items = try context.fetch(request)
            guard let entity = items.first else {
                return item
            }
            entity.isSet.toggle()
            try context.save()
            return Item(entity) ?? item
        } catch {
            print(error)
            return item
        }
    }

    func create(item: Item) {
        let context = itemBackgroundContext
        let entity = ItemEntity(context: context)
        entity.id = item.id
        entity.text = item.text
        entity.isSet = item.isSet
        do {
            try context.save()
        } catch {
            print(error)
        }
    }

    func fetch(itemWithId id: Item.ID) -> Item? {
        let context = itemBackgroundContext
        let request = ItemEntity.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", id as CVarArg)
        request.fetchLimit = 1
        do {
            let items = try context.fetch(request)
            guard let entity = items.first else {
                return nil
            }
            return Item(entity)
        } catch {
            print(error)
            return nil
        }
    }

    func remove(itemWithId id: Item.ID) throws {
        let context = itemBackgroundContext
        let request = ItemEntity.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", id as CVarArg)
        request.fetchLimit = 1
        let items = try context.fetch(request)
        guard let entity = items.first else {
            throw CoreDataError.noElementWithId(id)
        }
        context.delete(entity)
        try context.save()
    }



    func update(itemWithId id: Item.ID, newText: String) -> Item? {
        let context = itemBackgroundContext
        let request = ItemEntity.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", id as CVarArg)
        request.fetchLimit = 1
        do {
            let items = try context.fetch(request)
            guard let entity = items.first else {
                return nil
            }
            entity.text = newText
            try context.save()
            return Item(entity)
        } catch {
            print(error)
            return nil
        }
    }


    func update(itemWithId id: Item.ID, isSet: Bool) -> Item? {
        let context = itemBackgroundContext
        let request = ItemEntity.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", id as CVarArg)
        request.fetchLimit = 1
        do {
            let items = try context.fetch(request)
            guard let entity = items.first else {
                return nil
            }
            entity.isSet = isSet
            try context.save()
            return Item(entity)
        } catch {
            print(error)
            return nil
        }
    }
}

extension Item {
    init?(_ entity: ItemEntity) {
        guard let id = entity.id, let text = entity.text else {
            return nil
        }
        self.id = id
        self.text = text
        self.isSet = entity.isSet
    }
}
