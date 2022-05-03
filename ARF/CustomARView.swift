//
//  CustomARView.swift
//  ARF
//
//  Created by Caleb Danielsen on 13/03/2022.
//

import RealityKit
import ARKit
import FocusEntity
import SwiftUI
import Combine

class CustomARView: ARView {
    var focusEntity: FocusEntity?
    var sessionSettings: SessionSettings
    
    private var peopleOcclusionCancellable: AnyCancellable?
    private var objectOcclusionCancellable: AnyCancellable?
    private var lidarDebugCancellable: AnyCancellable?
    private var multiUserCancellable: AnyCancellable?
    
    required init(frame frameRect: CGRect, sessionSettings: SessionSettings) {
        self.sessionSettings = sessionSettings

        super.init(frame: frameRect)
        focusEntity = FocusEntity(on: self, focus: .classic)
        configure()
        initializeSettings()
        setupSubscribers()
    }
    
    @objc required dynamic init?(coder decoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc required dynamic init(frame frameRect: CGRect) {
        fatalError("init(frame:) has not been implemented")
    }
    
    private func configure() {
        let config = ARWorldTrackingConfiguration()
        config.planeDetection = [.horizontal, .vertical]
        // Enable LIDAR Functionality
        if ARWorldTrackingConfiguration.supportsSceneReconstruction(.mesh) {
            config.sceneReconstruction = .mesh
        }
        session.run(config)
    }
    
    private func initializeSettings() {
        updatePeopleOcclusion(isEnabled: sessionSettings.isPeopleOccusionEnabled)
        updateObjectOcclusion(isEnabled: sessionSettings.isObjectOccusionEnabled)
        updateLidarDebug(isEnabled: sessionSettings.isLidarDebugEnabled)
        updateMultiUser(isEnabled: sessionSettings.isMultiuserEnabled)
    }
    
    private func setupSubscribers() {
        peopleOcclusionCancellable = sessionSettings.$isPeopleOccusionEnabled.sink { [weak self] isEnabled in
            self?.updatePeopleOcclusion(isEnabled: isEnabled)
        }
        
        peopleOcclusionCancellable = sessionSettings.$isObjectOccusionEnabled.sink { [weak self] isEnabled in
            self?.updatePeopleOcclusion(isEnabled: isEnabled)
        }
        
        peopleOcclusionCancellable = sessionSettings.$isLidarDebugEnabled.sink { [weak self] isEnabled in
            self?.updatePeopleOcclusion(isEnabled: isEnabled)
        }
        peopleOcclusionCancellable = sessionSettings.$isMultiuserEnabled.sink { [weak self] isEnabled in
            self?.updatePeopleOcclusion(isEnabled: isEnabled)
        }
    }
    
    private func updatePeopleOcclusion(isEnabled: Bool) {
        print("\(#file): isPeopleOcclusionEnabled is now \(isEnabled)")
        
        guard ARWorldTrackingConfiguration.supportsFrameSemantics(.personSegmentationWithDepth) else { return }
        
        guard let configuration = session.configuration as? ARWorldTrackingConfiguration else { return }
        
        if configuration.frameSemantics.contains(.personSegmentationWithDepth) {
            configuration.frameSemantics.remove(.personSegmentationWithDepth)
        } else {
            configuration.frameSemantics.insert(.personSegmentationWithDepth)
        }
        
        session.run(configuration)
    }
    
    private func updateObjectOcclusion(isEnabled: Bool) {
        print("\(#file): isObjectOcclusionEnabled is now \(isEnabled)")
        
        if environment.sceneUnderstanding.options.contains(.occlusion) {
            environment.sceneUnderstanding.options.remove(.occlusion)
        } else {
            environment.sceneUnderstanding.options.insert(.occlusion)
        }
    }
    
    private func updateLidarDebug(isEnabled: Bool) {
        print("\(#file): isLidarDebugEnabled is now \(isEnabled)")
        
        if debugOptions.contains(.showSceneUnderstanding) {
            debugOptions.remove(.showSceneUnderstanding)
        } else {
            debugOptions.insert(.showSceneUnderstanding)
        }
    }
    
    private func updateMultiUser(isEnabled: Bool) {
        print("\(#file): isMultiUserEnabled is now \(isEnabled)")
    }
}
