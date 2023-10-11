//  Created by Axel Ancona Esselmann on 10/9/23.
//

import SwiftUI
import DebugSwiftUI

@main
struct ExtremelyLargeListsApp: App {

    @StateObject
    var appLoader = AppLoader()

    init() {
//        Constants.mockItemCount = 1000000
//        Constants.generateOnAppLaunch = true
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
