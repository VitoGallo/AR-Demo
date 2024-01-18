//
//  GlassButtonStyle.swift
//  AR-Demo
//
//  Created by Vito Gallo on 14/01/24.
//

import SwiftUI

/// A custom button style that provides a glass appearance
struct GlassButtonStyle<S: Shape>: ButtonStyle {
    
    // MARK: - PROPERTIES
    
    /// Indicates whether the view associated with this environment allows user interaction
    @Environment(\.isEnabled) var isEnabled: Bool
    /// The shape of the button
    var shape: S
    /// The font to apply to the button text
    var title: Font?
    
    // MARK: - METHODS
    
    /// Change the representation of the button body according to the given configuration
    ///
    /// - Parameter configuration: The button configuration
    ///
    /// - Returns: A view representing the body of the button
    func makeBody(configuration: Configuration) -> some View {
        
        configuration.label
            .font(title)
            .padding(title != nil ? (title == .largeTitle ? 20 : 10) : 0)
            .foregroundColor(.white)
            .background{
                GlassBackground(shape: shape)
            }
            .opacity(configuration.isPressed ? 0.7 : 1)
            .contentShape(shape)
    }
}

#Preview {
    GlassButtonStyle(shape: Circle()) as! any View
}
