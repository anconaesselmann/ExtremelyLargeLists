//  Created by Axel Ancona Esselmann on 10/10/23.
//

import SwiftUI

@MainActor
class LoadingManager: ObservableObject {

    @Published
    var isLoading: Bool = false
}
