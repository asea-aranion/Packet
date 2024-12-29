//
//  BagEditComponent.swift
//  Packet
//
//  Created by Leia Spagnola on 12/28/24.
//

import SwiftUI

struct BagEditComponent: View {
    
    @Environment(\.modelContext) var modelContext
    
    @AppStorage("theme") var theme: Int = 0
    
    @State var bag: Bag
    
    var body: some View {
        
        GeometryReader { geometry in
            
            HStack(spacing: 0) {
                
                if (bag.inEditMode) {
                    VStack(spacing: 0) {
                        RoundedRectangle(cornerRadius: 10)
                            .fill(.clear)
                            .frame(height: 5)
                        TextField("Category name", text: $bag.name)
                            .font(.system(size: 18, weight: .bold))
                            .multilineTextAlignment(.leading)
                        RoundedRectangle(cornerRadius: 10)
                            .fill((Theme(rawValue: theme) ?? .blue).get2())
                            .frame(height: 5)
                        
                    }
                    .padding(.horizontal, 15)
                    .frame(width: geometry.size.width * 0.6)
                }
                else {
                    Text(bag.name)
                        .font(.system(size: 18, weight: .bold))
                        .multilineTextAlignment(.leading)
                        .padding(.leading, 15)
                        .frame(width: geometry.size.width * 0.6, alignment: .leading)
                }
                
                
                Button {
                    bag.inEditMode.toggle()
                } label: {
                    Image(systemName: bag.inEditMode ? "checkmark" : "pencil")
                        .font(.system(size: 20, weight: .heavy))
                        .padding(geometry.size.width * 0.04)
                        .clipShape(Circle())
                        .foregroundStyle((Theme(rawValue: theme) ?? .blue).get2())
                        .frame(width: geometry.size.width * 0.2)
                }
                
                Button {
                    //modelContext.delete(bag)
                } label: {
                    Image(systemName: "trash")
                        .foregroundStyle(.red)
                        .font(.system(size: 20, weight: .heavy))
                        .padding(geometry.size.width * 0.04)
                        .clipShape(Circle())
                        .frame(width: geometry.size.width * 0.2)
                }
            }
        }
        .padding(10)
        .background(Color("Background"))
        .clipShape(RoundedRectangle(cornerRadius: 10))
        .frame(height: 80)
        .padding(.top, 10)
        .buttonStyle(.plain)
    }
}
