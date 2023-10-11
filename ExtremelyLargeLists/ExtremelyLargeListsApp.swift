//  Created by Axel Ancona Esselmann on 10/9/23.
//

import SwiftUI
import DebugSwiftUI

@main
struct ExtremelyLargeListsApp: App {

    @StateObject
    var appLoader = AppLoader()

    init() {
        // Note: Running the app with this line uncommented will populate CoreData with 1,000,000 aditional random items on app launch
//        Constants.generateAditionalItemsOnAppLaunch = true

        // Note: To see when a view gets redrawn uncomment this line
//        SwiftUIDebugManager.shared.isDebugging = true
    }

    var body: some Scene {
        WindowGroup {
            switch appLoader.initializationState {
            case .loading:
                ProgressView()
                    .task {
                        await appLoader.initialize()
                    }
            case .error(let error):
                Text("Error: \(error.localizedDescription)")
            case .loaded(let state):
                RootView()
                    .environmentObject(state.loadingManager)
                    .environmentObject(state.splitViewManager)
            }
        }
    }
}
