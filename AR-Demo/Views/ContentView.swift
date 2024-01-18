//
//  ContentView.swift
//  AR-Demo
//
//  Created by Vito Gallo on 14/01/24.
//

import SwiftUI
import RealityKit

/// Main view of the AR application.
struct ContentView : View {
    
    // MARK: - PROPERTIES
    
    /// The ViewModel object for managing the logic of the AR experience
    @ObservedObject var arViewModel: ARViewModel
    /// The ViewModel object for managing content and interactions in the AR scene
    @ObservedObject var contentViewModel: ContentViewModel

    // MARK: - BODY OF VIEW
    
    var body: some View {
        
        ZStack{
            
            // AR VIEW
            ARViewContainer(arViewModel: arViewModel, contentViewModel: contentViewModel)
                .edgesIgnoringSafeArea(.all)
            
            // Switch for displaying overlay views
            switch (contentViewModel.isPlacementEnabled, contentViewModel.isPickerPresented) {
            case (false, false):
                // BUTTONS VIEW
                ButtonPanelView(arViewModel: arViewModel, contentViewModel: contentViewModel)
                
            case (true, false):
                // PLACEMENT VIEW
                ARModelPlacementView(contentViewModel: contentViewModel)
                
            case (false, true):
                // SELECTION VIEW
                ARModelSelectionView(arViewModel: arViewModel, contentViewModel: contentViewModel)
                
            default: EmptyView()
            }
        }
        // Apply flash effect when needed
        .flash(contentViewModel: contentViewModel)
    }
}


#Preview {
    ContentView(arViewModel: ARViewModel(), contentViewModel: ContentViewModel())
}
