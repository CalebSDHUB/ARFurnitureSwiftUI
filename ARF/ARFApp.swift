//
//  ARFApp.swift
//  ARF
//
//  Created by Caleb Danielsen on 13/03/2022.

// Progress: Video 17 - Episode 16 - Reality School
//

import SwiftUI

@main
struct ARFApp: App {
    
    @StateObject var placementSettings = PlacementSettings()
    @StateObject var sessionSettings = SessionSettings()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(placementSettings)
                .environmentObject(sessionSettings)
        }
    }
}
