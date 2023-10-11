//  Created by Axel Ancona Esselmann on 10/10/23.
//

import SwiftUI
import DebugSwiftUI

struct RootView: View {

    @EnvironmentObject
    var splitViewManager: SplitViewManager

    var body: some View {
        VStack {
            DebugView(self)
            SplitViewContainer(layout: $splitViewManager.layout) {
                ItemList()
            } right: { id in
                ItemEditView(id: id)
                    .id(id)
                    .frame(width: 300)
            }
        }
    }
}
