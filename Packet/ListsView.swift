//
//  ListsView.swift
//  Packet
//
//  Created by Leia Spagnola on 12/23/24.
//

import SwiftUI
import SwiftData

struct ListsView: View {
    
    @Query var lists: [List]
    var userInfo: UserInfo
    
    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVStack {
                    ForEach(lists) { list in
                        GeometryReader { geometry in
                            NavigationLink(destination: EditListView(list: list)) {
                                ZStack {
                                    VStack(spacing: 0) {
                                        Rectangle()
                                            .fill(Color(red: list.colorRed, green: list.colorGreen, blue: list.colorBlue))
                                            .frame(width: geometry.size.width, height: geometry.size.height * 0.15)
                                            .padding(0)
                                        Rectangle()
                                            .fill(.quinary)
                                            .frame(width: geometry.size.width, height: geometry.size.height * 0.85)
                                            .padding(0)
                                    }
                                    
                                    
                                    HStack {
                                        Text(list.name)
                                            .font(.system(size: 20, weight: .bold))
                                            .padding(.leading, 10)
                                        Spacer()
                                        
                                        Image(systemName: "chevron.right")
                                        
                                            .padding(.trailing, 15)
                                            .buttonStyle(.plain)
                                    }
                                }
                            }
                            .buttonStyle(.plain)
                        }
                        
                        .frame(height: 80)
                        .clipShape(RoundedRectangle(cornerSize: .init(width: 10, height: 10)))
                        .padding(15)
                        
                    }
                }
                
            }
            .navigationTitle("Packing Lists")
        }
    }
}
