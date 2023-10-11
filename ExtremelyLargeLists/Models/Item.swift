//  Created by Axel Ancona Esselmann on 10/10/23.
//

import Foundation

struct Item: Identifiable, Equatable {
    let id: UUID
    var text: String
    var isSet: Bool

    init(id: UUID = UUID(), text: String, isSet: Bool) {
        self.id = id
        self.text = text
        self.isSet = isSet
    }
}
