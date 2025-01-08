//
//  TemplateComponent.swift
//  Packet
//
//  Created by Leia Spagnola on 1/6/25.
//

import SwiftUI

struct TemplateComponent: View {
    
    var list: TemplateList
    
    @Binding var path: NavigationPath
    
    @AppStorage("theme") var theme = 0
    
    var body: some View {
        ZStack(alignment: .init(horizontal: .leading, vertical: .top)) {
            Rectangle()
                .fill((Theme(rawValue: theme) ?? .blue).get2())
                .frame(height: 10)
                .frame(maxWidth: .infinity)
                .padding(0)
            
            HStack(alignment: .center) {
                VStack(alignment: .leading, spacing: 0) {
                    Text(list.name)
                        .font(.system(size: 20, weight: .bold))
                        .padding(.bottom, 5)
                    
                }
                .padding(.leading, 15)
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.system(size: 24, weight: .heavy))
                    .padding(.trailing, 15)
                    .buttonStyle(.plain)
                
            }
            .padding(.vertical, 25)
        }
        .background(.quinary)
        .clipShape(RoundedRectangle(cornerRadius: 10))
        .padding(15)
        .onTapGesture {
            path.append(list)
        }
        
    }
}