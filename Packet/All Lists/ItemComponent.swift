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
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text(String(item.quantity))
                    .padding(10)
                    .background(.quaternary)
                    .clipShape(Circle())
                Text(item.name)
                    .padding(.leading, 3)
                Spacer()
            }
            HStack(spacing: 10) {
                Text("\(Image(systemName: "tag")) \(item.category?.name ?? "(No category)")")
                Text("\(Image(systemName: "bag")) \(item.bag?.name ?? "(No bag)")")
                Spacer()
            }
            .foregroundStyle((Theme(rawValue: theme) ?? .blue).get2())
        }
        .frame(maxWidth: .infinity)
        .padding(10)
        .background(.quinary)
        .clipShape(RoundedRectangle(cornerRadius: 10))
        
    }
}
