//
//  PlacementSettings.swift
//  ARF
//
//  Created by Caleb Danielsen on 13/03/2022.
//

import SwiftUI
import RealityKit
import Combine

class PlacementSettings: ObservableObject {
    
    // When the user selects a model in BrowseView, this property is set.
    @Published var selectedModel: Model? {
        willSet(newValue) {
            print("Setting selectedModel to \(String(describing: newValue?.name))")
        }
    }
    
    // When the user taps confirm in PlacementView, the value of selectedModel is assigned to confirmed.
    @Published var confirmedModel: Model? {
        willSet(newValue) {
            guard let model = newValue else {
                print("Clearing confirmModel")
                return
            }
            
            print("Setting confirmModel to \(model.name)")
            
            recentlyPlaced.append(model)
        }
    }
    
    // This property retains a record of placed models in the scene. The last element in the array is the most recently placed model.
    
    @Published var recentlyPlaced: [Model] = []
    
    // This property retains the cancallable object for our SceneEvents.Update subscriber.
    var sceneObserver: Cancellable?
}
