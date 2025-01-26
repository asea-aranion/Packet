//
//  AddLabelComponent.swift
//  Packet
//
//  Created by Leia Spagnola on 1/22/25.
//

import SwiftUI

struct AddLabelComponent: View {
    
    var color: Color
    var text: String
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("\(Image(systemName: "plus.circle")) \(text)")
                .foregroundStyle(color)
                .bold()
            
            RoundedRectangle(cornerRadius: 10)
                .fill(color)
                .frame(height: 8)
            
        }
        .frame(height: 60)
        .padding(.top, 10)
        .padding(.horizontal, 15)
    }
}
