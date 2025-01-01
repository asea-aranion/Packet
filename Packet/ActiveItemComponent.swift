//
//  ActiveItemComponent.swift
//  Packet
//
//  Created by Leia Spagnola on 12/31/24.
//

import SwiftUI

struct ActiveItemComponent: View {
    
    @Bindable var item: Item
    @Binding var itemToEdit: Item?
    
    @AppStorage("theme") var theme: Int = 0
    
    var showCategory: Bool = false
    
    var body: some View {
        
        HStack {
            Button {
                withAnimation(.linear(duration: 0.1)) {
                    item.checked.toggle()
                }
            } label: {
                Image(systemName: item.checked ? "checkmark.circle" : "circle")
                    .foregroundStyle((Theme(rawValue: theme) ?? .blue).get2())
                    .font(.system(size: 24))
                    .padding(5)
                
            }
            Button {
                itemToEdit = item
            } label: {
                Text(String(item.quantity))
                    .padding(10)
                    .background(.quinary)
                    .clipShape(Circle())
                Text(item.name)
                    .padding(.leading, 3)
                Image(systemName: "circle.fill")
                    .font(.system(size: 8))
                Text(item.bag?.name ?? "(No bag)")
                Spacer()
            }
            
        }
        .padding(.horizontal, 10)
        .padding(.vertical, 5)
        
        
    }
    
}
