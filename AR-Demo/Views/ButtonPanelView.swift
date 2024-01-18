//
//  ButtonPanelView.swift
//  AR-Demo
//
//  Created by Vito Gallo on 14/01/24.
//

import SwiftUI
import RealityKit

/// Structure representing the button panel view overlaid on the AR view
struct ButtonPanelView: View {
    
    // MARK: - PROPERTIES
    
    /// The custom ARView object that hosts the AR experience
    @EnvironmentObject var arView: CustomARView
    
    /// The ViewModel object for managing the logic of the AR experience
    @ObservedObject var arViewModel: ARViewModel
    /// The ViewModel object for managing content and interactions in the AR scene
    @ObservedObject var contentViewModel: ContentViewModel
    
    // MARK: - BODY OF VIEW
    
    var body: some View {
        VStack{
            
            // RESET BUTTON
            Button(action: { contentViewModel.removeAllAnchors(arViewModel: arViewModel, in: arView)
            }, label: {
                Text("Reset")
            })
            .buttonStyle(GlassButtonStyle(shape: RoundedRectangle(cornerRadius: 10), title: .body))
            .frame(maxWidth: .infinity, alignment: .trailing)
            
            Spacer()
            
            HStack(alignment: .bottom){
                
                if arView.isObjectTapped {
                    // OBJECT SELECTED
                    ObjectSelectionComponent(arViewModel: arViewModel)
                } else {
                    // ADD BUTTON
                    Button(action: {
                        contentViewModel.openPicker(contentViewModel.isPickerPresented)
                    }, label: {
                        Image(systemName: "plus")
                    })
                    .buttonStyle(GlassButtonStyle(shape: RoundedRectangle(cornerRadius: 25), title: .largeTitle))
                }
                
                Spacer()
                
                // CAMERA BUTTON
                Button(action: {
                    contentViewModel.takeSnapshot(arView: arView, shouldFlash: contentViewModel.shouldFlash)
                }, label: {
                    Image(systemName: "camera")
                })
                .buttonStyle(GlassButtonStyle(shape: RoundedRectangle(cornerRadius: 25), title: .largeTitle))
            }
        }
        .padding(20)
    }
    
}

#Preview {
    ButtonPanelView(arViewModel: ARViewModel(), contentViewModel: ContentViewModel())
}
