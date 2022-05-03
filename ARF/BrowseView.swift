//
//  BrowseView.swift
//  ARF
//
//  Created by Caleb Danielsen on 13/03/2022.
//

import SwiftUI

struct BrowseView: View {
    
    @Binding var showBrowse: Bool
    
    var body: some View {
        NavigationView {
            ScrollView(showsIndicators: false) {
                RecentGrid(showBrowse: $showBrowse)
                ModelByCategoryGrid(showBrowse: $showBrowse)
            }
            .navigationBarTitle("Browse", displayMode: .large)
            .navigationBarItems(trailing:
                                    Button(action: {
                                        showBrowse.toggle()
                                    }, label: {
                                        Text("Done")
                                            .bold()
                                    })
            )
        }
    }
}

struct RecentGrid: View {
    
    @EnvironmentObject var placementSettings: PlacementSettings
    @Binding var showBrowse: Bool
    
    var body: some View {
        if !placementSettings.recentlyPlaced.isEmpty {
            HorizontalGrid(showBrowse: $showBrowse, title: "Recents", items: getRecentsUniqueOrdered())
        }
    }
    
    func getRecentsUniqueOrdered() -> [Model]{
        var recentsUniqueOrderedArray: [Model] = []
        var modelNameSet: Set<String> = []
        
        for model in placementSettings.recentlyPlaced.reversed() {
            if !modelNameSet.contains(model.name) {
                recentsUniqueOrderedArray.append(model)
                modelNameSet.insert(model.name)
            }
        }
        
        return recentsUniqueOrderedArray
    }
}

struct ModelByCategoryGrid: View {
    
    @Binding var showBrowse: Bool
    
    let models = Models()
    
    var body: some View {
        VStack {
            ForEach(ModelCategory.allCases, id: \.self) { category in
                // Only display grid if contains items
                if let modelByCategory = models.get(category: category) {
                    HorizontalGrid(showBrowse: $showBrowse, title: category.label, items: modelByCategory)
                }
            }
        }
    }
}

struct HorizontalGrid: View {
    
    @Binding var showBrowse: Bool
    @EnvironmentObject var placementSettings: PlacementSettings
    
    var title: String
    var items: [Model]
    private let gridItemLayout = [GridItem(.fixed(150))]
    
    var body: some View {
        VStack(alignment: .leading) {
            Separator()
            
            Text(title)
                .font(.title2).bold()
                .padding(.leading, 22)
                .padding(.top, 10)
            
            ScrollView(.horizontal, showsIndicators: false) {
                LazyHGrid(rows: gridItemLayout, spacing: 30) {
                    ForEach(0..<items.count) { index in
                        let model = items[index]
                        ItemButton(model: model) {
                            model.asyncLoadModelEntity()
                            placementSettings.selectedModel = model
                            print("Browse: selected \(model.name) for placement")
                            showBrowse = false
                        }
                    }
                }
                .padding(.horizontal, 22)
                .padding(.vertical, 10)
            }
        }
    }
}

struct ItemButton: View {
    let model: Model
    let action: () -> Void
    
    var body: some View {
        Button(action: {
            action()
        }, label: {
            Image(uiImage: model.thumbnail)
                .resizable()
                .aspectRatio(1, contentMode: .fill)
//                .frame(height: 50)
                .background(Color(UIColor.secondarySystemFill))
                .cornerRadius(8)
        })
    }
}

struct Separator: View {
    var body: some View {
        Divider()
            .padding(.horizontal, 20)
            .padding(.vertical, 10)
    }
}
