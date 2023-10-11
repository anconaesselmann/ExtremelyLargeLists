//  Created by Axel Ancona Esselmann on 10/10/23.
//

import SwiftUI

enum SplitViewContainerLayout<RightData> {
    case onlyLeft, onlyRight(RightData), all(RightData)

    var isLeftVisible: Bool {
        switch self {
        case .onlyLeft, .all: return true
        case .onlyRight: return false
        }
    }

    var isRightVisible: Bool {
        switch self {
        case .onlyRight, .all: return true
        case .onlyLeft: return false
        }
    }
}

struct None {

}

struct SplitViewContainer<Left, Right, RightData>: View
    where Left: View, Right: View
{

    @Binding
    var layout: SplitViewContainerLayout<RightData>

    @ViewBuilder
    let left: () -> Left

    @ViewBuilder
    let right: (RightData) -> Right

    var body: some View {
#if os(macOS)
        HSplitView {
            if layout.isLeftVisible {
                left()
            }
            switch layout {
            case .onlyRight(let data), .all(let data):
                right(data)
            default: EmptyView()
            }
        }
#else
        left()
#endif
    }
}
