//
//  ContentView.swift
//  ARF
//
//  Created by Caleb Danielsen on 13/03/2022.
//

import SwiftUI
import RealityKit

struct ContentView: View {
    
    @EnvironmentObject var placementSettings: PlacementSettings
    @State private var isControlVisible: Bool = true
    @State private var showBrowse: Bool = false
    @State private var showSettings: Bool = false
    
    var body: some View {
        ZStack(alignment: .bottom) {
            ARViewContainer()
            
            if placementSettings.selectedModel == nil {
                ControlView(isControlVisible: $isControlVisible, showBrowse: $showBrowse, showSettings: $showSettings)
            } else {
                PlacementView()
            }

        }
        .ignoresSafeArea()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(PlacementSettings())
            .environmentObject(SessionSettings())
    }
}

struct ARViewContainer: UIViewRepresentable {
    
    @EnvironmentObject var placementSettings: PlacementSettings
    @EnvironmentObject var sessionSettings: SessionSettings
    
    func makeUIView(context: Context) -> CustomARView {
        let customARView = CustomARView(frame: .zero, sessionSettings: sessionSettings)
        placementSettings.sceneObserver = customARView.scene.subscribe(to: SceneEvents.Update.self, { event in
            updateScene(for: customARView)
        })
        return customARView
    }
    
    func updateUIView(_ uiView: CustomARView, context: Context) {
        
    }
    
    private func updateScene(for customARView: CustomARView) {
        // Only display focusEntity when the user has selected a model for placement.
        customARView.focusEntity?.isEnabled = placementSettings.selectedModel != nil
        
        // Add model to scene if confirmed for placement.
        if let confirmedModel = placementSettings.confirmedModel,
           let modelEntity = confirmedModel.modelEntity {
            
            place(modelEntity, in: customARView)
            
            placementSettings.confirmedModel = nil
        }
    }
    
    private func place(_ modelEntity: ModelEntity, in arView: ARView) {
        // 1. Clone modelEntity. This creates an identical copy of modelEntity and references the same model. This also allows us to have multiple model of the same asset in our scene.
        let clonedEntity = modelEntity.clone(recursive: true)
        
        // 2. Enable translation and rotation gestures.
        clonedEntity.generateCollisionShapes(recursive: true)
        arView.installGestures([.translation, .rotation], for: clonedEntity)
        // 3. Create an anchorEntity nad add clonedEntity to the anchorEntity.
        let anchorEntity = AnchorEntity(plane: .any)
        anchorEntity.addChild(clonedEntity)
        // 4. Add the anchorEntity to the arView.scene
        arView.scene.addAnchor(anchorEntity)
        
        print("Added modelEntity to scene.")
    }
}
