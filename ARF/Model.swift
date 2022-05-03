//
//  Model.swift
//  ARF
//
//  Created by Caleb Danielsen on 13/03/2022.
//

import SwiftUI
import RealityKit
import Combine

enum ModelCategory: CaseIterable {
//    case table
    case chair
    case decor
//    case light
    
    var label: String {
        get {
            switch self {
//            case .table: return "Tables"
            case .chair: return "Chairs"
            case .decor: return "Decor"
//            case .light: return "Light"
            }
        }
    }
}

class Model {
    var name: String
    var category: ModelCategory
    var thumbnail: UIImage
    var modelEntity: ModelEntity?
    var scaleCompensation: Float
    private var cancellable: AnyCancellable?
    
    init(name: String, category: ModelCategory, scaleCompensation: Float = 1.0) {
        self.name = name
        self.category = category
        self.thumbnail = UIImage(named: name) ?? UIImage(systemName: "photo")!
        self.scaleCompensation = scaleCompensation
    }
    func asyncLoadModelEntity() {
        let filename = name + ".usdz"
        
        cancellable = ModelEntity.loadModelAsync(named: filename)
            .sink { (loadCompletion) in
                switch loadCompletion {
                case .failure(let error): print("Unable to load modelEntity for \(filename). Error: \(error.localizedDescription)")
                case .finished: break
                }
            } receiveValue: { modelEntity in
                self.modelEntity = modelEntity
                self.modelEntity?.scale *= self.scaleCompensation
                
                print("ModelEntity for \(self.name) has been loaded.")
            }
    }
}

struct Models {
    var all: [Model] = []
    
    private let scale: Float = 100/100
    
    init() {
        // Tables
        let diningTable = Model(name: "chair_swan", category: .chair, scaleCompensation: scale)
        let watercan = Model(name: "wateringcan", category: .decor, scaleCompensation: scale)
        let teapot = Model(name: "teapot", category: .decor, scaleCompensation: scale)
        
        all.append(contentsOf: [diningTable, watercan, teapot])
    }
    
    func get(category: ModelCategory) -> [Model] {
        all.filter { $0.category == category }
    }
}
