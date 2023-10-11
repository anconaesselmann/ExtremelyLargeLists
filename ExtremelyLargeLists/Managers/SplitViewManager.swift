//  Created by Axel Ancona Esselmann on 10/10/23.
//

import SwiftUI

class SplitViewManager: ObservableObject {

    @Published
    var layout: SplitViewContainerLayout<UUID> = .onlyLeft
}
