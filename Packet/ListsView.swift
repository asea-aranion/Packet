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
    
    @Query var lists: [List]
    
    @State var path: NavigationPath = NavigationPath()
    
    var body: some View {
        NavigationStack(path: $path) {
            ScrollView {
                LazyVStack {
                    Button {
                        let newList = List()
                        modelContext.insert(newList)
                    } label: {
                        VStack(alignment: .leading) {
                            Text("\(Image(systemName: "plus.circle")) Add List")
                                .font(.system(size: 18, weight: .bold))
                            
                            RoundedRectangle(cornerRadius: 10)
                                .fill(.green)
                                .frame(height: 8)
                            
                        }
                        
                        .frame(height: 60)
                        .padding(.top, 10)
                        .padding([.leading, .trailing], 15)
                    }
                    .buttonStyle(.plain)
                    .foregroundStyle(.green)
                    
                    ForEach(lists) { list in
                        GeometryReader { geometry in
                            Button {
                                path.append(list)
                            } label: {
                                ZStack(alignment: .init(horizontal: .leading, vertical: .top)) {
                                    Rectangle()
                                        .fill(Color(red: list.colorRed, green: list.colorGreen, blue: list.colorBlue))
                                        .frame(width: geometry.size.width, height: geometry.size.height * 0.15)
                                        .padding(0)
                                    
                                    HStack(alignment: .center) {
                                        Text(list.name)
                                            .font(.system(size: 20, weight: .bold))
                                            .padding(.leading, 15)
                                        Spacer()
                                        
                                        Image(systemName: "chevron.right")
                                            .font(.system(size: 24, weight: .heavy))
                                            .padding(.trailing, 15)
                                            .buttonStyle(.plain)
                                    }
                                    .frame(height: geometry.size.height)
                                }
                            }
                            .buttonStyle(.plain)
                        }
                        .background(.quinary)
                        .frame(height: 80)
                        .clipShape(RoundedRectangle(cornerSize: .init(width: 10, height: 10)))
                        .padding(15)
                        
                    }
                }
                
            }
            .navigationTitle("Packing Lists")
            .navigationDestination(for: List.self) { list in
                EditListView(list: list, path: $path)
            }
        }
    }
}
