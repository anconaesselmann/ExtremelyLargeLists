//  Created by Axel Ancona Esselmann on 10/10/23.
//

import Foundation
import LoremSwiftum

extension DataController {
    func generate() {
        let items =  (0..<Constants.mockItemCount).map { _ in
            Item(text: Lorem.fullName, isSet: false)
        }
        let context = container.newBackgroundContext()
        for item in items {
            let entity = ItemEntity(context: context)
            entity.id = item.id
            entity.text = item.text
            entity.isSet = item.isSet
            context.insert(entity)
        }
        do {
            try context.save()
        } catch {
            print(error)
        }
    }
}
