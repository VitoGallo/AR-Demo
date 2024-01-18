//
//  ContentViewModel.swift
//  AR-Demo
//
//  Created by Vito Gallo on 14/01/24.
//

import SwiftUI

/// View model for managing the content and interaction in the AR scene
class ContentViewModel: ObservableObject {
    
    // MARK: - PROPERTIES
    
    /// Indicates whether the model selection view is presented
    @Published var isPickerPresented: Bool = false
    /// Indicates whether model positioning is enabled
    @Published var isPlacementEnabled: Bool = false
    /// Represents the AR model selected by the user for placement
    @Published var selectedModel: ARModel?
    /// Indicates whether the selected model has been confirmed
    @Published var isModelConfirmed: Bool = false
    /// Indicates whether the flash effect should be activated
    @Published var shouldFlash: Bool = false
    
    // MARK: - METHODS
    
    /// Removes all anchors associated with objects in the ARViewModel
    ///
    /// - Parameters:
    ///   - arViewModel: The ARViewModel managing AR anchors and entities
    ///   - arView: The `CustomARView` where the anchors are displayed
    func removeAllAnchors(arViewModel: ARViewModel, in arView: CustomARView) {
        arViewModel.anchorEntities.keys.forEach { $0.removeFromParent() }
        arView.selectedObjectForDeletion = nil
    }
    
    /// Open the selector with smooth animation
    ///
    /// - Parameter isPickerPresented: A boolean indicating whether the model selector is presented
    func openPicker(_ isPickerPresented: Bool) {
        withAnimation(.easeIn(duration: 0.5)){
            self.isPickerPresented = true
        }
    }
    
    /// Closes the model selection view with a smooth animation
    ///
    /// - Parameter isPickerPresented: A boolean indicating whether the model selector is presented
    func dismissPicker(_ isPickerPresented: Bool){
        withAnimation(.easeIn(duration: 0.5)){
            self.isPickerPresented = false
        }
    }
    
    /// Select an AR model and enable positioning
    ///
    /// - Parameters:
    ///   - model: The selected AR model
    ///   - isPickerPresented: A boolean indicating whether the model selector is presented
    ///   - isPlacementEnabled: A boolean indicating whether model positioning is enabled
    func selectModel(_ model: ARModel, isPickerPresented: Bool, isPlacementEnabled: Bool) {
        selectedModel = model
        dismissPicker(isPickerPresented)
        self.isPlacementEnabled = true
    }
    
    /// Exit placement mode
    ///
    /// - Parameter isPlacementEnabled: A boolean indicating whether model positioning is enabled
    func resetPlacement(_ isPlacementEnabled: Bool){
        self.isPlacementEnabled = false
    }
    
    /// Take a snapshot and save it in the photo album
    ///
    /// - Parameters:
    ///   - arView: The CustomARView used for the AR experience
    ///   - shouldFlash: A boolean indicating whether the flash effect should be activated
    func takeSnapshot(arView: CustomARView, shouldFlash: Bool){
        self.shouldFlash = true
        
        arView.snapshot(saveToHDR: false){ image in
            guard let compressedImage = UIImage(data: image?.pngData() ?? Data()) else { return }
            UIImageWriteToSavedPhotosAlbum(compressedImage, nil, nil, nil)
        }
    }
    
}
