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
                    
                }
                .padding(.leading, 15)
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.system(size: 24, weight: .bold))
                    .padding(.trailing, 15)
                    .buttonStyle(.plain)
                    .accessibilityHint("Opens template editor")
                
            }
            .padding(.vertical, 25)
        }
        .background(.quinary)
        .clipShape(RoundedRectangle(cornerRadius: 10))
        .padding(.vertical, 10)
        .padding(.horizontal, 15)
        .onTapGesture {
            path.append(list)
        }
        
    }
}
