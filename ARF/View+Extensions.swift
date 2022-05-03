//
//  View+Extensions.swift
//  ARF
//
//  Created by Caleb Danielsen on 14/03/2022.
//

import SwiftUI

extension View {
    @ViewBuilder func hidden(_ shouldHide: Bool) -> some View {
        switch shouldHide {
        case true: hidden()
        case false: self
        }
    }
}
