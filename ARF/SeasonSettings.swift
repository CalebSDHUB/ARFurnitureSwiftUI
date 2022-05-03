//
//  SeasonSettings.swift
//  ARF
//
//  Created by Caleb Danielsen on 14/03/2022.
//

import SwiftUI

class SessionSettings: ObservableObject {
    @Published var isPeopleOccusionEnabled: Bool = false
    @Published var isObjectOccusionEnabled: Bool = false
    @Published var isLidarDebugEnabled: Bool = false
    @Published var isMultiuserEnabled: Bool = false
}
