//
//  ARModel.swift
//  AR-Demo
//
//  Created by Vito Gallo on 14/01/24.
//

import SwiftUI
import RealityKit
import Combine

/// An AR model with functionality for asynchronous loading of 3D models
class ARModel: Identifiable{
    
    // MARK: - PROPERTIES
    
    /// A unique identifier for the AR model
    var id = UUID()
    /// The name of the AR model
    var modelName: String
    /// The image associated with the AR model
    var image: Image
    /// The entity of the associated 3D model
    var modelEntity: ModelEntity?
    
    // MARK: - INITIALIZATION
    
    /// Initializes an ARModel object with the specified model name
    ///
    /// - Parameter modelName: The name of the model.
    init (modelName: String){
        self.modelName = modelName
        self.image = Image(modelName)
    }
    
}
