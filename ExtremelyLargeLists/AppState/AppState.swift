//  Created by Axel Ancona Esselmann on 10/10/23.
//

import Foundation

struct AppState {
    let store: any PersistentStore
    let loadingManager: LoadingManager
    let itemUpdateManager: ItemUpdateManager
    let splitViewManager: SplitViewManager

    // The only force-unwrapped property is the singleton.
    static var shared: AppState!
}
