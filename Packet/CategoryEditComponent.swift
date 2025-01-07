//
//  CategoryEditComponent.swift
//  Packet
//
//  Created by Leia Spagnola on 12/25/24.
//

import SwiftUI

struct CategoryEditComponent: View {
    
    @Environment(\.modelContext) var modelContext
    
    @AppStorage("theme") var theme: Int = 0
    
    @Bindable var category: Category
    
    var body: some View {
        
        HStack(spacing: 0) {
            
            VStack(spacing: 0) {
                
                if (category.inEditMode) {
                    TextField("Category name", text: $category.name)
                        .font(.system(size: 18, weight: .bold))
                        .multilineTextAlignment(.leading)
                        .padding(.top, 5)
                }
                else {
                    Text(category.name)
                        .font(.system(size: 18, weight: .bold))
                        .multilineTextAlignment(.leading)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.top, 6)
                }
                
                RoundedRectangle(cornerRadius: 10)
                    .fill((Theme(rawValue: theme) ?? .blue).get2())
                    .frame(height: 5)
                    .frame(maxWidth: category.inEditMode ? .infinity : 0)
                    .padding(0)
            }
            .padding(.horizontal, 10)
            .padding(.vertical, 10)
            
            if (category.inEditMode) {
                Button {
                    withAnimation(.easeInOut) {
                        category.inEditMode = false
                    }
                } label: {
                    Image(systemName: "checkmark")
                        .font(.system(size: 20, weight: .heavy))
                        .padding(.horizontal, 15)
                        .foregroundStyle((Theme(rawValue: theme) ?? .blue).get2())
                }
                
                Button {
                    //modelContext.delete(category)
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
                        category.inEditMode = true
                        
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
        .padding(.top, 10)
        .buttonStyle(.plain)
    }
}
