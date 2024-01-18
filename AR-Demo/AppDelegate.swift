//
//  AppDelegate.swift
//  AR-Demo
//
//  Created by Vito Gallo on 14/01/24.
//

import UIKit
import SwiftUI

/// The main application delegate responsible for handling app lifecycle events
@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    /// The main application window
    var window: UIWindow?
    
    // MARK: - APP INITIALIZATION
    
    /// Called when the application is launched
    ///
    /// - Parameters:
    ///   - application: The singleton app object
    ///   - launchOptions: A dictionary containing data passed to the app at launch time
    ///
    /// - Returns: A boolean indicating whether the app launch was successful
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        // Create AR components
        @ObservedObject var arView = CustomARView(frame: .zero)
        
        // Create the SwiftUI view that provides the window contents
        let contentView = ContentView(arViewModel: ARViewModel(), contentViewModel: ContentViewModel())
            .environmentObject(arView)
        
        // Initialize the main application window
        let window = UIWindow(frame: UIScreen.main.bounds)
        window.rootViewController = UIHostingController(rootView: contentView)
        self.window = window
        
        // Make the window visible
        window.makeKeyAndVisible()
        
        // Indicate that the application launch was successful
        return true
    }
    
    // MARK: - APP LIFECYCLE METHODS
    
    /// Called when the application is about to become inactive
    ///
    /// - Parameter application: The singleton app object
    func applicationWillResignActive(_ application: UIApplication) {
        // Perform tasks to pause ongoing activities (e.g., disable timers)
    }
    
    /// Called when the application enters the background
    ///
    /// - Parameter application: The singleton app object
    func applicationDidEnterBackground(_ application: UIApplication) {
        // Save data, release resources, and prepare for possible termination
    }
    
    /// Called when the application is about to enter the foreground
    ///
    /// - Parameter application: The singleton app object
    func applicationWillEnterForeground(_ application: UIApplication) {
        // Undo changes made when the application entered the background
    }
    
    /// Called when the application becomes active
    ///
    /// - Parameter application: The singleton app object
    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused or not yet started while the application was inactive.
        // Optionally refresh the user interface.
    }
    
}

