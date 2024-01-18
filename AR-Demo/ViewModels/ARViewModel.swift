//
//  ARViewModel.swift
//  AR-Demo
//
//  Created by Vito Gallo on 14/01/24.
//

import SwiftUI
import Combine
import RealityKit

/// ViewModel for managing the AR experience
class ARViewModel: ObservableObject {
    
    // MARK: - PROPERTIES
    
    /// The AR models available
    var models: [ARModel] {
        guard let files = try? FileManager.default.contentsOfDirectory(atPath: Bundle.main.resourcePath ?? "") else { return [] }
        
        return files
            .filter { $0.hasSuffix("usdz") }
            .map { ARModel(modelName: URL(fileURLWithPath: $0).deletingPathExtension().lastPathComponent) }
    }
    
    /// A dictionary that associates `AnchorEntity` instances with a boolean value indicating the animation state
    var anchorEntities: [AnchorEntity : Bool] = [:]
    /// Set of cancelables for managing Combine subscriptions
    var cancellables: Set<AnyCancellable> = Set()
    
    // MARK: - METHODS
    
    /// Loads a model asynchronously and adds it to the AR scene
    ///
    /// - Parameters:
    ///   - modelName: The name of the model to load and add
    ///   - arView: The AR view in which to add the model
    func loadModelToScene(_ modelName: String, in arView: ARView){
        let model = ARModel(modelName: modelName)
        
        ModelEntity
            .loadModelAsync(named: modelName + ".usdz")
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { completion in
                    
                    // Handle any errors or loading completions
                    if case .failure = completion {
                        print("Unable to load modelEntity for model \(modelName)")
                    }
                    
                }, receiveValue: { [weak self] modelEntity in
                    guard let self = self else { return }
                    
                    // Set the ModelEntity in the model
                    model.modelEntity = modelEntity
                    // Generate collision shapes for the model
                    modelEntity.generateCollisionShapes(recursive: true)
                    // Add the model to the AR scene
                    addModelToScene(model, in: arView)
                })
            .store(in: &cancellables)
    }
    
    /// Adds the model to the AR scene
    ///
    /// - Parameters:
    ///   - model: The model to add to the scene
    ///   - arView: The AR view in which to add the model
    func addModelToScene(_ model: ARModel, in arView: ARView) {
        guard let modelEntity = model.modelEntity else { return }
        modelEntity.name = model.modelName
        
        // Creates an entity anchored to a flat surface
        let anchorEntity = AnchorEntity(plane: .any)
        anchorEntity.addChild(modelEntity.clone(recursive: true))
        
        // Add the anchored entity to the AR scene
        arView.scene.addAnchor(anchorEntity)
        // Add the anchored entity to the list of anchored entities
        anchorEntities[anchorEntity] = true
    }
    
    /// Manages the removal of the selected object from the AR scene
    ///
    /// - Parameter arView: The custom AR view where the object removal is initiated
    func handleObjectRemoval(in arView: CustomARView) {
        arView.isObjectTapped = false
        
        // Get the anchor and anchor identifier associated with the selected object
        guard let anchor = arView.selectedObjectForDeletion?.anchor,
              let anchoringIdentifier = anchor.anchorIdentifier,
              let index = anchorEntities.keys.firstIndex(where: {$0.anchorIdentifier == anchoringIdentifier}) else { return }
        
        // Remove the anchored entity and anchor from the scene
        anchorEntities.remove(at: index)
        anchor.removeFromParent()
        
        arView.selectedObjectForDeletion = nil
    }
    
    ///  Checks if animations are available on the specified anchor entity
    ///
    /// - Parameter anchorEntity: The anchor entity to check for available animations
    ///
    /// - Returns: `true` if animations are available, `false` otherwise
    func areAnimationsAvailable(on anchorEntity: ModelEntity?) -> Bool{
        guard let anchor = anchorEntity?.anchor else { return true }
        return !anchor.availableAnimations.isEmpty
    }
    
    ///  Checks the status of animation for the selected object in the AR view
    ///
    /// - Parameter arView: The `CustomARView` where the selected object is displayed
    ///
    /// - Returns: The animation status for the selected object. Returns `true` if animations are available, `false` otherwise
    func areAnimationsActive(in arView: CustomARView) -> Bool{
        guard let anchor = arView.selectedObjectForDeletion?.anchor else { return false }

        return anchorEntities[anchor as! AnchorEntity]!
    }
    
    /// Plays infinite animations on the specified AnchorEntity
    ///
    /// - Parameters:
    ///   - anchorEntity: The AnchorEntity on which to play the infinite animations
    ///   - arView: The `CustomARView` where the selected object is displayed
    func playInfiniteAnimations(on anchorEntity: AnchorEntity, in arView: CustomARView) {
        anchorEntities[anchorEntity]?.toggle()
        
        for animation in anchorEntity.availableAnimations {
            anchorEntity.playAnimation(animation.repeat(duration: .infinity), transitionDuration: 1.25, startsPaused: areAnimationsActive(in: arView))
        }
    }
}
