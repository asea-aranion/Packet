//
//  ListComponent.swift
//  Packet
//
//  Created by Leia Spagnola on 12/30/24.
//

import SwiftUI

struct ListComponent: View {
    
    var list: PackingList
    
    @Binding var path: NavigationPath
    
    var body: some View {
        GeometryReader { geometry in
            Button {
                path.append(list)
            } label: {
                ZStack(alignment: .init(horizontal: .leading, vertical: .top)) {
                    Rectangle()
                        .fill(Color(red: list.colorRed, green: list.colorGreen, blue: list.colorBlue))
                        .frame(width: geometry.size.width, height: geometry.size.height * 0.1)
                        .padding(0)
                    
                    HStack(alignment: .center) {
                        VStack(alignment: .leading, spacing: 0) {
                            Text(list.name)
                                .font(.system(size: 20, weight: .bold))
                                .padding(.bottom, 5)
                                
                            Text(list.startDate.formatted(date: .abbreviated, time: .omitted) + " - " + list.endDate.formatted(date: .abbreviated, time: .omitted))
                                .font(.system(size: 18))
                        }
                        .padding(.leading, 15)
                        
                        Spacer()
                        
                        Image(systemName: "chevron.right.circle")
                            .font(.system(size: 24, weight: .bold))
                            .padding(.trailing, 15)
                            .buttonStyle(.plain)
                    }
                    .padding(.vertical, 20)
                }
                
            }
            .buttonStyle(.plain)
        }
        .frame(minHeight: 100)
        .background(.quinary)
        .clipShape(RoundedRectangle(cornerRadius: 10))
        .padding(15)
        
    }
}
