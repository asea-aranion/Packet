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
    
    @State var category: Category
    
    var body: some View {
        HStack {
            
            if (category.inEditMode) {
                TextField("Category name", text: $category.name)
                    .font(.system(size: 20, weight: .bold))
                    .padding(15)
                    .multilineTextAlignment(.leading)
                    .textFieldStyle(.roundedBorder)
                    .padding([.top, .bottom], 5)
            }
            else {
                Text(category.name)
                    .font(.system(size: 20, weight: .bold))
                    .padding(15)
                    .multilineTextAlignment(.leading)
                    .padding([.top, .bottom], 5)
            }
            
            
            Spacer()
            
            Button {
                category.inEditMode.toggle()
            } label: {
                Image(systemName: category.inEditMode ? "checkmark" : "pencil")
                    .font(.system(size: 24, weight: .heavy))
                    .padding(15)
                    .background(.ultraThinMaterial)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .padding(10)
            }
            
            Button {
                modelContext.delete(category)
            } label: {
                Image(systemName: "trash")
                    .foregroundStyle(.red)
                    .font(.system(size: 24, weight: .heavy))
                    .padding(15)
                    .background(.ultraThinMaterial)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .padding(10)
            }
        }
        .foregroundStyle((ColorScheme(rawValue: theme) ?? .blue).get2())
        .padding([.top, .bottom], 5)
        .buttonStyle(.plain)
    }
}
