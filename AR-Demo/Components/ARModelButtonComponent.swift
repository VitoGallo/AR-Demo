//
//  ARModelButtonComponent.swift
//  AR-Demo
//
//  Created by Vito Gallo on 14/01/24.
//

import SwiftUI

/// A component that represents a button to select an AR model
struct ARModelButtonComponent: View {
    
    // MARK: - PROPERTIES
    
    /// The AR model associated with the button
    let model: ARModel
    /// The closure to execute when the button is selected
    let onSelect: (ARModel) -> Void
    /// The width of the screen
    let screenWidth: CGFloat = UIScreen.main.bounds.size.width
    
    // MARK: - BODY OF VIEW
    
    var body: some View {
        
        Button(action: {
            onSelect(model)
        }, label: {
            model.image
                .resizable()
                .frame(height: screenWidth / 2 - 50)
                .aspectRatio(1/1, contentMode: .fit)
                .cornerRadius(12)
        })
        .buttonStyle(GlassButtonStyle(shape: RoundedRectangle(cornerRadius: 25)))
    }
}

#Preview {
    ARModelButtonComponent(model: ARModel(modelName: "")){ _ in }
}
