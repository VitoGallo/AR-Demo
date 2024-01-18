//
//  FlashModifier.swift
//  AR-Demo
//
//  Created by Vito Gallo on 14/01/24.
//

import SwiftUI

/// A view modifier that adds a "flash" effect over the main view
struct FlashModifier: ViewModifier {
    
    // MARK: - PROPERTIES
    
    /// The ViewModel object for managing content and interactions in the AR scene
    @ObservedObject var contentViewModel: ContentViewModel
    
    // MARK: - BODY OF VIEW
    
    func body(content: Content) -> some View {
        
        ZStack{
            content
            
            if contentViewModel.shouldFlash{
                FlashView(contentViewModel: contentViewModel)
                    .ignoresSafeArea(.all)
            }
        }
    }
}
