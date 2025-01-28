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
    @State var showArchived: Bool = false
    
    @AppStorage("theme") var theme: Int = 0
    
    var body: some View {
        NavigationStack(path: $path) {
            ScrollView {
                VStack {
                    
                    // MARK: Menu for 3 different create list options
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
                    
                    // MARK: Unarchived lists
                    ForEach(lists.filter({
                        !$0.archived
                    })) { list in
                        ListComponent(list: list, path: $path, inDuplicateMode: $inDuplicateMode)
                    }
                    
                    // MARK: Label and toggle for showing archived lists
                    HStack {
                        Text("Archived Lists")
                            .foregroundStyle((Theme(rawValue: theme) ?? .blue).get1())
                            .font(.title3).bold()
                            .padding(.horizontal, 30)
                            .padding(.vertical, 15)
                            .background((Theme(rawValue: theme) ?? .blue).get2())
                            .clipShape(UnevenRoundedRectangle(cornerRadii:
                                    .init(topLeading: 10, bottomLeading: 0, bottomTrailing: 0, topTrailing: 10)))
                            .padding(.leading, 15)
                            .padding(.top, 20)
                        Spacer()
                        Button {
                            withAnimation {
                                showArchived.toggle()
                            }
                        } label: {
                            Image(systemName: "chevron.down.circle")
                                .font(.system(size: 28, weight: .bold))
                                .padding(.horizontal, 10)
                                .foregroundStyle((Theme(rawValue: theme) ?? .blue).get2())
                                .rotationEffect(Angle(degrees: showArchived ? -90 : 0))
                                .animation(.easeInOut, value: showArchived)
                        }
                        .padding(.top, 20)
                    }
                    
                    // MARK: Archived lists
                    if (showArchived) {
                        ForEach(lists.filter({
                            $0.archived
                        })) { list in
                            ListComponent(list: list, path: $path, inDuplicateMode: $inDuplicateMode)
                        }
                        .transition(.move(edge: .top).combined(with: .opacity))
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
