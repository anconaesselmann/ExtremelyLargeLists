//  Created by Axel Ancona Esselmann on 10/10/23.
//

import SwiftUI

struct LoadingView: View {

    @EnvironmentObject
    var loadingManager: LoadingManager

    var body: some View {
        if loadingManager.isLoading {
            ProgressView()
        }
    }
}
