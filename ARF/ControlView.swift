//
//  ControlView.swift
//  ARF
//
//  Created by Caleb Danielsen on 13/03/2022.
//

import SwiftUI

struct ControlView: View {
    
    @Binding var isControlVisible: Bool
    @Binding var showBrowse: Bool
    @Binding var showSettings: Bool
    
    var body: some View {
        VStack {
            
            ControllVisibilityToogleButton(isControlVisible: $isControlVisible)
            
            Spacer()
            
            if isControlVisible {
                ControlButtonBar(showBrowse: $showBrowse, showSettings: $showSettings)
            }
        }
    }
}


struct ControllVisibilityToogleButton: View {
    
    @Binding var isControlVisible: Bool
    
    var body: some View {
        HStack {
            
            Spacer()
            
            ZStack {
                Color.black.opacity(0.25)
                
                Button(action: {
                    print("Control visibility toggle button pressed.")
                    isControlVisible.toggle()
                }, label: {
                    Image(systemName: isControlVisible ? "rectangle" : "slider.horizontal.below.rectangle")
                        .font(.system(size: 35))
                        .foregroundColor(.white)
                        .buttonStyle(PlainButtonStyle())
                })
            }
            .frame(width: 70, height: 70)
            .cornerRadius(8)
        }
        .padding(.top, 45)
        .padding(.trailing, 20)
    }
}

struct ControlButtonBar: View {
    
    @EnvironmentObject var placementSettings: PlacementSettings
    @Binding var showBrowse: Bool
    @Binding var showSettings: Bool
    
    var body: some View {
        HStack {
            
            MostRecentlyPlaceButton().hidden(placementSettings.recentlyPlaced.isEmpty)
            
            ControlButton(systemIconName: "clock.fill") {
                print("MostRecentlyPlaced button pressed")
            }
            
            Spacer()
            
            ControlButton(systemIconName: "square.grid.2x2") {
                print("Browse button pressed")
                showBrowse.toggle()
            }.sheet(isPresented: $showBrowse, content: {
                BrowseView(showBrowse: $showBrowse)
            })
            
            Spacer()
            
            ControlButton(systemIconName: "slider.horizontal.3") {
                print("Settings button pressed")
                showSettings.toggle()
            }
            .sheet(isPresented: $showSettings) {
                SettingsView(showSettings: $showSettings)
            }
        }
        .frame(maxWidth: .infinity)
        .padding(30)
        .background(Color.black.opacity(0.25))
    }
}


struct ControlButton: View {
    
    let systemIconName: String
    let action: () -> Void
    
    var body: some View {
        Button(action: {
            action()
        }, label: {
            Image(systemName: systemIconName)
                .font(.system(size: 35))
                .foregroundColor(.white)
                .buttonStyle(PlainButtonStyle())
        })
        .frame(width: 50, height: 50)
    }
}

struct MostRecentlyPlaceButton: View {
    
    @EnvironmentObject var placementSettings: PlacementSettings
    
    var body: some View {
        Button {
            print("Most recently Placed button pressed")
            placementSettings.selectedModel = placementSettings.recentlyPlaced.last
        } label: {
            if let mostRecentlyPlaceModel = placementSettings.recentlyPlaced.last {
                Image(uiImage: mostRecentlyPlaceModel.thumbnail)
                    .resizable()
                    .aspectRatio(1, contentMode: .fit)
                    .frame(width: 46)
            } else {
                Image(systemName: "clock.fill")
                    .font(.system(size: 35))
                    .foregroundColor(.white)
                    .buttonStyle(PlainButtonStyle())
            }
        }
        .frame(width: 50, height: 50)
        .background(Color.white)
        .cornerRadius(8)

    }
}
