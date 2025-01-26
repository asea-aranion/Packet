//
//  ListsView.swift
//  Packet
//
//  Created by Leia Spagnola on 12/23/24.
//

import SwiftUI
import SwiftData

struct ListsView: View {
    
    @Environment(\.modelContext) var modelContext
    
    @Query(sort: \PackingList.startDate, order: .reverse) var lists: [PackingList]
    @Query var templates: [TemplateList]
    
    @State var path: NavigationPath = NavigationPath()
    @State var inDuplicateMode: Bool = false
    
    @AppStorage("theme") var theme: Int = 0
    
    var body: some View {
        NavigationStack(path: $path) {
            ScrollView {
                VStack {
                    Menu {
                        Button("New empty list") {
                            let newList = PackingList()
                            modelContext.insert(newList)
                            path.append(newList)
                        }
                        Menu("Create from template") {
                            ForEach(templates) { template in
                                Button(template.name) {
                                    let newList = PackingList(from: template)
                                    modelContext.insert(newList)
                                    path.append(newList)
                                }
                            }
                        }
                        Button("Duplicate a list") {
                            inDuplicateMode = true
                        }
                        
                    } label: {
                        AddLabelComponent(color: ((Theme(rawValue: theme) ?? .blue).get2()), text: "Add List")
                    }
                    .buttonStyle(.plain)
                    
                    ForEach(lists) { list in
                        ListComponent(list: list, path: $path, inDuplicateMode: $inDuplicateMode)
                    }
                }
                .padding(.bottom, 15)
                
            }
            .navigationTitle("Packing Lists")
            .navigationDestination(for: PackingList.self) { list in
                EditListView(list: list, path: $path)
            }
            .background((Theme(rawValue: theme) ?? .blue).get1())
        }
    }
}
