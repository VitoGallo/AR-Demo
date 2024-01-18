//
//  View.swift
//  AR-Demo
//
//  Created by Vito Gallo on 14/01/24.
//

import SwiftUI

extension View {
    /// Apply a "flash" effect to the view.
    ///
    /// - Parameter contentViewModel: The `ContentViewModel` associated with the flash effect
    ///
    /// - Returns: The view with the "flash" effect applied
    func flash(contentViewModel: ContentViewModel) -> some View {
        self.modifier(FlashModifier(contentViewModel: contentViewModel))
    }
}
