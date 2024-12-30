//
//  ItemComponent.swift
//  Packet
//
//  Created by Leia Spagnola on 12/23/24.
//

import SwiftUI

struct ItemComponent: View {
    
    var item: Item
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text(String(item.quantity))
                    .padding(10)
                    .background(.quinary)
                    .clipShape(Circle())
                Text(item.name)
                    .padding(.leading, 3)
                Spacer()
            }
            HStack {
                Text(item.category?.name ?? "(No category)")
                    .font(.system(size: 18))
                Image(systemName: "circle.fill")
                    .font(.system(size: 8))
                Text(item.bag?.name ?? "(No bag)")
                    .font(.system(size: 18))
                Spacer()
            }
            .padding(5)
        }
        .frame(maxWidth: .infinity)
        .padding(10)
        .background(.quinary)
        .clipShape(RoundedRectangle(cornerRadius: 10))
        
    }
}
