//
//  CustomARView.swift
//  AR-Demo
//
//  Created by Vito Gallo on 14/01/24.
//

import SwiftUI
import RealityKit
import ARKit
import FocusEntity

/// A subclass of ARView that handles visualization and interactions within an augmented reality environment
///
/// This class includes functionality for configuring the AR session, managing focus, and selecting/deselecting touched objects
class CustomARView: ARView, ObservableObject {
    
    // MARK: - PROPERTIES
    
    /// Entity used to provide visual clues to the status of AR tracking
    var trackingIndicatorEntity: FocusEntity?
    /// Property to indicate whether an object has been touched
    @Published var isObjectTapped: Bool = false
    /// Properties for the object currently selected for removal
    @Published var selectedObjectForDeletion: ModelEntity? = nil
    
    // MARK: - INITIALIZATION
    
    /// Custom initialization method for the ARView
    ///
    /// - Parameter frameRect: The frame rectangle defining the view's location and size in its superview's coordinate system
    required init(frame frameRect: CGRect) {
        // Call the designated initializer of the superclass (UIView)
        super.init(frame: frameRect)
        
        // Configure the AR session and set up the focus entity for tracking status
        configureARSession()
        // Enable object selection via tap gesture
        enableObjectSelection()
    }
    
    // MARK: - METHODS
    
    /// Required initializer when initializing from storyboard or nib files
    ///
    /// - Parameter decoder: An archiver for encoding or decoding data
    @objc required dynamic init?(coder decoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// Set up the initial AR session and set the focus amount to provide visual clues to the tracking status
    private func configureARSession(){
        // Create and set up a FocusEntity to provide visual tracking status cues
        trackingIndicatorEntity = FocusEntity(on: self, focus: .classic)
        // Configure the AR world tracking session
        setupARWorldTrackingConfiguration()
    }
    
    /// Set AR tracking configuration with flat surface detection and automatic settings
    private func setupARWorldTrackingConfiguration() {
        
        // Create an ARWorldTrackingConfiguration
        let config = ARWorldTrackingConfiguration()
        config.planeDetection = [.horizontal, .vertical]
        config.environmentTexturing = .automatic
        
        // Check if scene reconstruction with mesh is supported
        if ARWorldTrackingConfiguration.supportsSceneReconstruction(.mesh) {
            config.sceneReconstruction = .mesh
        }
        
        // Run the AR session with the configured tracking settings
        session.run(config)
    }
    
    /// Enable object selection via tap gesture
    private func enableObjectSelection(){
        // Create a tap gesture recognizer
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTapGesture))
        // Add the tap gesture recognizer to the ARView
        self.addGestureRecognizer(tapGesture)
    }
    
    /// Manages the tap gesture on the view and the selection/deselection of the touched objects
    ///
    /// - Parameter recognizer: The tap gesture recognizer
    @objc private func handleTapGesture(recognizer: UITapGestureRecognizer){
        // Get the touch location in the ARView
        let touchLocation = recognizer.location(in: self)
        
        // Check if there is a ModelEntity at the touch location
        if let tappedObject = self.entity(at: touchLocation) as? ModelEntity{
            handleSelectedEntity(tappedObject)
        }else{
            handleDeselectedEntity()
        }
    }
    
    /// Manages the selection of a touched object
    ///
    /// - Parameter object: The selected object
    private func handleSelectedEntity(_ object: ModelEntity) {
        // Reset debug options for the previously selected object
        selectedObjectForDeletion?.modelDebugOptions = nil
        
        // Set debug options for the currently selected object for better visualization
        let debugOptionsComponent = ModelDebugOptionsComponent(visualizationMode: .lightingDiffuse)
        object.modelDebugOptions = debugOptionsComponent
        
        // Update the selectedObjectForDeletion property
        selectedObjectForDeletion = object
        
        // Install gestures for the selected object to enable interactions
        self.installGestures([.all], for: object)
        
        isObjectTapped = true
    }
    
    /// Manages the deselection of a touched object
    private func handleDeselectedEntity() {
        selectedObjectForDeletion?.modelDebugOptions = nil
        selectedObjectForDeletion = nil
        isObjectTapped = false
    }
    
}

