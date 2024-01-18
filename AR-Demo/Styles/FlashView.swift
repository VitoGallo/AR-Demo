//
//  FlashView.swift
//  AR-Demo
//
//  Created by Vito Gallo on 14/01/24.
//

import SwiftUI
import AudioToolbox

/// A representation of UIView to create a "flash" effect with a camera closing sound
struct FlashView: UIViewRepresentable {
    
    // MARK: - PROPERTIES
    
    /// The ViewModel object for managing content and interactions in the AR scene
    @ObservedObject var contentViewModel: ContentViewModel
    
    /// The camera closing sound loaded from an MP3 audio file
    var cameraShutterSound: SystemSoundID {
        var soundID:SystemSoundID = 1000
        
        if let soundURL = Bundle.main.url(forResource: "shutter", withExtension: ".mp3") {
            AudioServicesCreateSystemSoundID(soundURL as CFURL, &soundID)
        }
        return soundID
    }
    
    // MARK: - METHODS
    
    /// Creates and returns a new UIView instance for FlashView.
    ///
    /// - Parameter context: The context in which the view creation is performed
    /// - Returns: A new UIView instance configured for FlashView
    func makeUIView(context: Context) -> UIView {
        let view = UIView()
        setupView(view)
        return view
    }
    
    /// Update the view by applying "flash" animation when `shouldFlash` changes
    ///
    /// - Parameters:
    ///   - view: The view to update
    ///   - context: The context in which the view update is performed
    func updateUIView(_ view: UIView, context: Context) {
        applyFlashAnimation(view, cameraShutterSound: cameraShutterSound)
    }
    
    /// Configure the initial appearance of the view
    ///
    /// - Parameter view: The view to configure
    private func setupView(_ view: UIView) {
        view.backgroundColor = .white
        view.alpha = 0
    }
    
    /// Apply "flash" animation to the view
    ///
    /// - Parameters:
    ///   - view: The view to apply the animation to
    ///   - cameraShutterSound: The system sound identifier for the camera shutter sound
    private func applyFlashAnimation(_ view: UIView, cameraShutterSound: SystemSoundID) {
        guard contentViewModel.shouldFlash else { return }
        
        playCameraShutterSound(cameraShutterSound)
        
        view.alpha = 1.0
        
        UIView.animate(withDuration: 1.0, delay: 0.0, options: .curveEaseOut, animations: {
            view.alpha = 0.0
        }) { _ in
            contentViewModel.shouldFlash = false
        }
    }
    
    /// Plays the camera closing sound.
    ///
    /// - Parameter cameraShutterSound: The system sound identifier for the camera shutter sound
    ///
    /// - Note: Use the pre-loaded sound from the "shutter" audio file
    private func playCameraShutterSound(_ cameraShutterSound: SystemSoundID) {
        AudioServicesPlaySystemSound(cameraShutterSound)
    }
}


#Preview {
    FlashView(contentViewModel: ContentViewModel())
}
