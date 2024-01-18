//
//  ARModelPlacementView.swift
//  AR-Demo
//
//  Created by Vito Gallo on 14/01/24.
//

import SwiftUI

/// A view that manages the positioning and confirmation of AR models within the AR environment
struct ARModelPlacementView: View {
    
    // MARK: - PROPERTIES
    
    /// The ViewModel object for managing content and interactions in the AR scene
    @ObservedObject var contentViewModel: ContentViewModel
    
    // MARK: - BODY OF VIEW
    
    var body: some View {
        
        HStack(spacing: 50){
            
            // CANCEL BUTTON
            Button(action: {
                contentViewModel.resetPlacement(contentViewModel.isPlacementEnabled)
            }, label: {
                Image(systemName: "xmark")
            })
            .buttonStyle(GlassButtonStyle(shape: Circle(), title: .largeTitle))
            
            // CONFIRM BUTTON
            Button(action: {
                contentViewModel.isModelConfirmed = true
                contentViewModel.resetPlacement(contentViewModel.isPlacementEnabled)
            }, label: {
                Image(systemName: "checkmark")
            })
            .buttonStyle(GlassButtonStyle(shape: Circle(), title: .largeTitle))
            
        }
        .frame(maxHeight: .infinity, alignment: .bottom)
        .padding(.bottom, 50)
    }
    
}

#Preview {
    ARModelPlacementView(contentViewModel: ContentViewModel())
}
