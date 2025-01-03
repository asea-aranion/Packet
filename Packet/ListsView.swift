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
    
    @State var path: NavigationPath = NavigationPath()
    
    @AppStorage("theme") var theme: Int = 0
    
    var body: some View {
        NavigationStack(path: $path) {
            ScrollView {
                LazyVStack {
                    Button {
                        let newList = PackingList()
                        modelContext.insert(newList)
                    } label: {
                        VStack(alignment: .leading) {
                            Text("\(Image(systemName: "plus.circle")) Add List")
                                .font(.system(size: 18, weight: .bold))
                            
                            RoundedRectangle(cornerRadius: 10)
                                .fill((Theme(rawValue: theme) ?? .blue).get2())
                                .frame(height: 8)
                            
                        }
                        
                        .frame(height: 60)
                        .padding(.top, 10)
                        .padding([.leading, .trailing], 15)
                    }
                    .buttonStyle(.plain)
                    .foregroundStyle((Theme(rawValue: theme) ?? .blue).get2())
                    
                    ForEach(lists) { list in
                        ListComponent(list: list, path: $path)
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
