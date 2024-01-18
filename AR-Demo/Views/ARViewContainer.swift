//
//  ARViewContainer.swift
//  AR-Demo
//
//  Created by Vito Gallo on 14/01/24.
//

import SwiftUI
import RealityKit
import ARKit

/// A structure representing a UIView container for displaying an AR experience
struct ARViewContainer: UIViewRepresentable {
    
    // MARK: - PROPERTIES
    
    /// The custom ARView object that hosts the AR experience
    @EnvironmentObject var arView: CustomARView
    
    /// The ViewModel object for managing the logic of the AR experience
    @ObservedObject var arViewModel: ARViewModel
    /// The ViewModel object for managing content and interactions in the AR scene
    @ObservedObject var contentViewModel: ContentViewModel
    
    // MARK: - METHODS
    
    /// Creates a new ARView instance and returns the corresponding UIView object.
    ///
    /// - Parameter context: The rendering context of the AR view within the SwiftUI hierarchy
    ///
    /// - Returns: A new instance of ARView configured for use within SwiftUI
    func makeUIView(context: Context) -> ARView {
        return arView
    }
    
    /// Updates the ARView with context changes.
    ///
    /// - Parameters:
    ///   - uiView: The ARView object to update
    ///   - context: The rendering context of the AR view within the SwiftUI hierarchy
    func updateUIView(_ uiView: ARView, context: Context) {
        // Configure the focus indicator
        configureFocusEntity()
        // Load the confirmed model into the ARView if it has been confirmed
        loadConfirmedModelIfNeeded(in: uiView)
    }
    
    /// Configure the focus indicator
    private func configureFocusEntity() {
        arView.trackingIndicatorEntity?.isEnabled = contentViewModel.selectedModel != nil
    }
    
    /// Load the confirmed model into the ARView if it has been confirmed
    ///
    /// - Parameter arView: The ARView object to load the model into
    private func loadConfirmedModelIfNeeded(in arView: ARView) {
        guard let selectedModel = contentViewModel.selectedModel, contentViewModel.isModelConfirmed else { return }
        // Load the confirmed model into the ARView using the ViewModel
        arViewModel.loadModelToScene(selectedModel.modelName, in: arView)
        
        // Reset the confirmed model after loading
        DispatchQueue.main.async {
            contentViewModel.selectedModel = nil
            contentViewModel.isModelConfirmed = false
        }
    }
}

#Preview {
    ARViewContainer(arViewModel: ARViewModel(), contentViewModel: ContentViewModel())
}
