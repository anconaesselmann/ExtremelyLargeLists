//  Created by Axel Ancona Esselmann on 10/10/23.
//

import SwiftUI

public extension Button {
    init(_ titleKey: LocalizedStringKey, action: @escaping () async -> Void)
        where Label == Text
    {
        self.init(titleKey, action: {
            Task {
                await action()
            }
        })
    }
}
