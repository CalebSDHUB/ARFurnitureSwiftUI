//
//  SettingsView.swift
//  ARF
//
//  Created by Caleb Danielsen on 14/03/2022.
//

import SwiftUI

enum Setting {
    case peopleOcclusion
    case objectOccclusion
    case lidarDebug
    case multiuser
    
    var label: String {
        get {
            switch self {
            case .peopleOcclusion, .objectOccclusion:
                return "Occlusion"
            case .lidarDebug: return "LIDAR"
            case .multiuser: return "Multiuser"
            }
        }
    }
    
    var systemIconName: String {
        get {
            switch self {
            case .peopleOcclusion:
                return "person"
            case .objectOccclusion:
                return "cube.box.fill"
            case .lidarDebug: return "light.min"
            case .multiuser: return "person.2"
            }
        }
    }
}

struct SettingsView: View {
    
    @Binding var showSettings: Bool
    
    var body: some View {
        NavigationView {
            SettingGrid()
                .navigationBarTitle(Text("Settings"), displayMode: .inline)
                .navigationBarItems(trailing:
                                        Button(action: {
                                            showSettings.toggle()
                                        }, label: {
                                            Text("Done").bold()
                                        })
                )
        }
    }
}

struct SettingGrid: View {
    
    @EnvironmentObject var sessionSettings: SessionSettings
    
    private var gridItemLayout = [GridItem(.adaptive(minimum: 100, maximum: 100), spacing: 25)]
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: gridItemLayout, spacing: 25) {
                SettingToggleButton(setting: .peopleOcclusion, isOn: $sessionSettings.isPeopleOccusionEnabled)
                
                SettingToggleButton(setting: .objectOccclusion, isOn: $sessionSettings.isObjectOccusionEnabled)
                
                SettingToggleButton(setting: .lidarDebug, isOn: $sessionSettings.isLidarDebugEnabled)
                
                SettingToggleButton(setting: .multiuser, isOn: $sessionSettings.isMultiuserEnabled)
            }
        }
        .padding(.top, 35)
    }
}

struct SettingToggleButton: View {
    
    let setting: Setting
    @Binding var isOn: Bool
    
    var body: some View {
        Button(action: {
            isOn.toggle()
            print("\(#file) - \(setting): \(isOn)")
        }, label: {
            VStack {
                Image(systemName: setting.systemIconName)
                    .font(.system(size: 35))
                    .foregroundColor(isOn ? .green : Color(UIColor.secondaryLabel))
                    .buttonStyle(PlainButtonStyle())
                
                Text(setting.label)
                    .font(.system(size: 17, weight: .medium, design: .default))
                    .foregroundColor(isOn ? Color(UIColor.label) : Color(UIColor.secondaryLabel))
                    .padding(.top, 5)
            }
        })
        .frame(width: 50, height: 50)
        .background(Color(UIColor.secondarySystemFill))
        .cornerRadius(20)
    }
}
