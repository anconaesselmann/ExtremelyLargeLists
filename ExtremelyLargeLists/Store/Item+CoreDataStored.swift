//  Created by Axel Ancona Esselmann on 10/13/23.
//

import Foundation
import CoreData
import CoreDataStored

extension ItemEntity: CoreDataIdentifiable { }

extension Item: CoreDataStored {
    func entity(existing entity: ItemEntity?, in context: NSManagedObjectContext) -> ItemEntity {
        let entity = entity ?? ItemEntity(context: context)
        entity.id = id
        entity.text = text
        entity.isSet = isSet
        return entity
    }

    init(_ entity: ItemEntity) throws {
        id = try UUID(enforceNotNil: entity.id)
        text = try String(enforceNotNil: entity.text)
        isSet = entity.isSet
    }
}
