//  Created by Axel Ancona Esselmann on 10/10/23.
//

import SwiftUI

@MainActor
class AppLoader: ObservableObject {

    enum InitializationState {
        case error(Error)
        case loading
        case loaded(AppState)
    }

    var initializationState: InitializationState = .loading

    func initialize() async {
        guard AppState.shared == nil else {
            return
        }
        let dataController = DataController()
        do {
            try await dataController.initialize()
            if Constants.generateOnAppLaunch {
                await dataController.generate()
            }
        } catch {
            self.initializationState = .error(error)
            self.objectWillChange.send()
            return
        }
        let loadingManager = LoadingManager()
        let itemUpdateManager = ItemUpdateManager()
        let splitViewManager = SplitViewManager()
        let appState = AppState(
            store: dataController,
            loadingManager: loadingManager,
            itemUpdateManager: itemUpdateManager,
            splitViewManager: splitViewManager
        )
        AppState.shared = appState
        initializationState = .loaded(appState)
        self.objectWillChange.send()
    }
}
