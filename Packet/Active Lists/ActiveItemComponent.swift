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
    var listColor: Color = .blue
    
    var body: some View {
        
        HStack {
            Button {
                withAnimation {
                    item.checked.toggle()
                }
            } label: {
                Image(systemName: item.checked ? "checkmark.circle" : "circle")
                    .foregroundStyle(listColor)
                    .font(.system(size: 24))
                    .padding(5)
                    .animation(.easeInOut(duration: 0.1), value: item.checked)
            }
            Button {
                itemToEdit = item
            } label: {
                Text(String(item.quantity))
                    .foregroundStyle(listColor)
                    .bold()
                    .frame(minWidth: 34, minHeight: 34)
                    .overlay {
                        Circle()
                            .stroke(listColor, lineWidth: 3)
                    }
                Text(item.name)
                    .padding(.horizontal, 3)
                if (showCategory) {
                    Text("\(Image(systemName: "tag.fill")) \(item.category?.name ?? "(No category)")")
                        .foregroundStyle((Theme(rawValue: theme) ?? .blue).get2())
                } else {
                    Text("\(Image(systemName: "bag.fill")) \(item.bag?.name ?? "(No bag)")")
                        .foregroundStyle((Theme(rawValue: theme) ?? .blue).get2())
                }
                Spacer()
            }
            
        }
        .padding(10)
        
        
    }
    
}
