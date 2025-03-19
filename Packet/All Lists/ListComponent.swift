//
//  ListComponent.swift
//  Packet
//
//  Created by Leia Spagnola on 12/30/24.
//

import SwiftUI

struct ListComponent: View {
    
    @Environment(\.modelContext) var modelContext
    
    var list: PackingList
    
    @Binding var path: NavigationPath
    @Binding var inDuplicateMode: Bool
    
    var body: some View {
        
            ZStack(alignment: .init(horizontal: .leading, vertical: .top)) {
                Rectangle()
                    .fill(Color(red: list.colorRed, green: list.colorGreen, blue: list.colorBlue))
                    .frame(height: 10)
                    .frame(maxWidth: .infinity)
                    .padding(0)
                
                HStack(alignment: .center) {
                    VStack(alignment: .leading, spacing: 0) {
                        Text(list.name)
                            .font(.title2)
                            .bold()
                            .padding(.bottom, 5)
                        
                        Text(list.startDate.formatted(date: .abbreviated, time: .omitted) + " - " + list.endDate.formatted(date: .abbreviated, time: .omitted))
                            .font(.title3)
                    }
                    .padding(.leading, 15)
                    
                    Spacer()
                    
                    if (inDuplicateMode) {
                        Button("Duplicate") {
                            let newList = PackingList.init(from: list)
                            modelContext.insert(newList)
                            inDuplicateMode.toggle()
                            path.append(newList)
                        }
                        .bold()
                        .padding(.vertical, 5)
                        .padding(.horizontal, 20)
                        .background(.quaternary)
                        .clipShape(Capsule())
                        .foregroundStyle(Color(red: list.colorRed, green: list.colorGreen, blue: list.colorBlue))
                        .padding(.trailing, 15)
                    } else {
                        Image(systemName: "chevron.right")
                            .font(.system(size: 24, weight: .bold))
                            .padding(.trailing, 15)
                            .buttonStyle(.plain)
                    }
                }
                .padding(.vertical, 25)
            }
            
        
        .background(.quinary)
        .clipShape(RoundedRectangle(cornerRadius: 10))
        .padding(15)
        .onTapGesture {
            if (!inDuplicateMode) {
                path.append(list)
            }
        }
    }
}
