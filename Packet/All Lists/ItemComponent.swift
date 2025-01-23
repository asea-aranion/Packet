//
//  ItemComponent.swift
//  Packet
//
//  Created by Leia Spagnola on 12/23/24.
//

import SwiftUI

struct ItemComponent: View {
    
    @AppStorage("theme") var theme = 0
    
    var item: Item
    var listColor: Color
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text(String(item.quantity))
                    .foregroundStyle(listColor)
                    .bold()
                    .frame(minWidth: 34, minHeight: 34)
                    .overlay {
                        Circle()
                            .stroke(listColor, lineWidth: 3)
                    }
                Text(item.name)
                    .padding(.leading, 3)
                Spacer()
            }
            .padding(.vertical, 5)
            HStack(spacing: 15) {
                Text("\(Image(systemName: "tag.fill")) \(item.category?.name ?? "(No category)")")
                Text("\(Image(systemName: "bag.fill")) \(item.bag?.name ?? "(No bag)")")
                Spacer()
            }
            .foregroundStyle((Theme(rawValue: theme) ?? .blue).get2())
            .padding(.bottom, 5)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 10)
        .padding(.horizontal, 15)
        .background(.quinary)
        .clipShape(RoundedRectangle(cornerRadius: 10))
        
    }
}
