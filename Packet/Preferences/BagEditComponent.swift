//
//  BagEditComponent.swift
//  Packet
//
//  Created by Leia Spagnola on 12/28/24.
//

import SwiftUI
import SwiftData

struct BagEditComponent: View {
    
    @Environment(\.modelContext) var modelContext
    
    @AppStorage("theme") var theme: Int = 0
    
    @Query var itemsWithBag: [Item]
    
    @Bindable var bag: Bag
    
    init(bag: Bag) {
        _bag = .init(bag)
        let id = bag.persistentModelID
        _itemsWithBag = Query(filter: #Predicate {
            $0.bag?.persistentModelID == id
        })
    }
    
    var body: some View {
        
        HStack(spacing: 0) {
            
            VStack(spacing: 0) {
                
                if (bag.inEditMode) {
                    TextField("Bag name", text: $bag.name)
                        .font(.system(size: 18, weight: .bold))
                        .multilineTextAlignment(.leading)
                        .padding(.top, 5)
                }
                else {
                    Text(bag.name)
                        .font(.system(size: 18, weight: .bold))
                        .multilineTextAlignment(.leading)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.top, 6)
                }
                
                RoundedRectangle(cornerRadius: 10)
                    .fill((Theme(rawValue: theme) ?? .blue).get2())
                    .frame(height: 5)
                    .frame(maxWidth: bag.inEditMode ? .infinity : 0)
                    .padding(0)
            }
            .padding(.horizontal, 10)
            .padding(.vertical, 10)
            
            if (bag.inEditMode) {
                Button {
                    withAnimation(.easeInOut) {
                        bag.inEditMode = false
                    }
                } label: {
                    Image(systemName: "checkmark")
                        .font(.system(size: 20, weight: .heavy))
                        .padding(.horizontal, 15)
                        .foregroundStyle((Theme(rawValue: theme) ?? .blue).get2())
                }
                
                Button {
                    itemsWithBag.forEach {
                        $0.bag = nil
                    }
                    modelContext.delete(bag)
                } label: {
                    Image(systemName: "trash")
                        .foregroundStyle(.red)
                        .font(.system(size: 20, weight: .heavy))
                        .padding(.horizontal, 10)
                }
            }
            else {
                Button("Edit") {
                    withAnimation(.easeInOut) {
                        bag.inEditMode = true
                        
                    }
                }
                .bold()
                .padding(.vertical, 5)
                .padding(.horizontal, 20)
                .background(.quaternary)
                .clipShape(Capsule())
                .foregroundStyle((Theme(rawValue: theme) ?? .blue).get2())
                .padding(.trailing, 10)
            }
        }
        .padding(10)
        .background(.quinary)
        .clipShape(RoundedRectangle(cornerRadius: 10))
        .padding(.vertical, 5)
        .buttonStyle(.plain)
    }
}
