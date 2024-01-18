//
//  ObjectSelectionComponent.swift
//  AR-Demo
//
//  Created by Vito Gallo on 14/01/24.
//

import SwiftUI
import RealityFoundation

/// This view represents the panel that appears when an object has been selected in the AR scene
struct ObjectSelectionComponent: View {
    
    /// The custom ARView object that hosts the AR experience
    @EnvironmentObject var arView: CustomARView
    
    /// The ViewModel object for managing the logic of the AR experience
    @ObservedObject var arViewModel: ARViewModel
    
    /// Indicates whether the animation is paused or not
    @State var isAnimationPaused = true
    
    // MARK: - BODY OF VIEW
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            
            // MARK: BUTTONS
            HStack {
                // DELETE BUTTON
                Button(action: {
                    arViewModel.handleObjectRemoval(in: arView)
                }) {
                    Image(systemName: "trash.fill")
                        .frame(width: 30, height: 30)
                }
                .buttonStyle(GlassButtonStyle(shape: RoundedRectangle(cornerRadius: 10), title: .title3))
                
                Spacer()
                
                // ANIMATION BUTTON
                if arViewModel.areAnimationsAvailable(on: arView.selectedObjectForDeletion){
                    Button(action: {
                        if let anchorEntity = arView.selectedObjectForDeletion?.anchor {
                            arViewModel.playInfiniteAnimations(on: anchorEntity as! AnchorEntity, in: arView)
                            isAnimationPaused = arViewModel.areAnimationsActive(in: arView)
                        }
                    }) {
                        Image(systemName: isAnimationPaused ? "play.fill" : "pause.fill")
                            .frame(width: 30, height: 30)
                    }
                    .buttonStyle(GlassButtonStyle(shape: RoundedRectangle(cornerRadius: 10), title: .title3))
                }
            }
            .frame(width: 125)
            .padding(.horizontal, 5)
            
            // MARK: SELECTED OBJECT
            VStack(spacing: 0) {
                // TEXT
                Text("Selected")
                    .font(.headline)
                    .foregroundColor(.white)
                
                // IMAGE
                Image(arView.selectedObjectForDeletion?.name ?? "")
                    .resizable()
                    .frame(width: 100, height: 100)
            }
            .frame(width: 125, height: 125)
            .padding(5)
            .background(GlassBackground(shape: RoundedRectangle(cornerRadius: 25)).opacity(0.4))
        }
        // When the selected object changes, update the animation state
        .onChange(of: arView.selectedObjectForDeletion){
            isAnimationPaused = arViewModel.areAnimationsActive(in: arView)
        }
    }
}

#Preview {
    ObjectSelectionComponent(arViewModel: ARViewModel())
}
