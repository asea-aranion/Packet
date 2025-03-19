//
//  PreferencesView.swift
//  Packet
//
//  Created by Leia Spagnola on 12/25/24.
//

import SwiftUI
import SwiftData

struct PreferencesView: View {
    
    @Environment(\.modelContext) var modelContext
    
    @Query var categories: [Category]
    @Query var bags: [Bag]
    
    @AppStorage("theme") var theme: Int = 0
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                
                // MARK: Display and picker for color theme
                Text("Theme")
                    .font(.title3).bold()
                    .foregroundStyle((Theme(rawValue: theme) ?? .blue).get1())
                    .padding(.horizontal, 30)
                    .padding(.vertical, 15)
                    .background((Theme(rawValue: theme) ?? .blue).get2())
                    .clipShape(UnevenRoundedRectangle(cornerRadii:
                            .init(topLeading: 10, bottomLeading: 0, bottomTrailing: 0, topTrailing: 10)))
                    .padding(.leading, 15)
                    .padding(.top, 20)
                
                LazyVGrid(columns: [
                    GridItem(.flexible(), spacing: 15), GridItem(.flexible(), spacing: 15), GridItem(.flexible(), spacing: 15), GridItem(.flexible(), spacing: 15)
                ], spacing: 15) {
                    
                    ForEach(Theme.allCases, id: \.self) { color in
                        Button {
                            UserDefaults.standard.set(color.rawValue, forKey: "theme")
                        } label: {
                            ZStack {
                                // draw a two-toned circle icon
                                Circle()
                                    .fill(color.get1())
                                Circle()
                                    .trim(from: 0.375, to: 0.875)
                                    .fill(color.get2())
                                // draw a white border around theme icon if it is selected
                                if (theme == color.rawValue) {
                                    Circle()
                                        .stroke(.white, lineWidth: 4)
                                }
                            }
                        }
                    }
                }
                .padding(.horizontal, 15)
                .padding(.top, 10)
                
                // MARK: Categories editor
                Text("Categories")
                    .font(.title3).bold()
                    .foregroundStyle((Theme(rawValue: theme) ?? .blue).get1())
                    .padding([.leading, .trailing], 30)
                    .padding([.top, .bottom], 15)
                    .background((Theme(rawValue: theme) ?? .blue).get2())
                    .clipShape(UnevenRoundedRectangle(cornerRadii:
                            .init(topLeading: 10, bottomLeading: 0, bottomTrailing: 0, topTrailing: 10)))
                    .padding(.leading, 15)
                    .padding(.top, 20)
                
                Button {
                    modelContext.insert(Category(name: "New Category"))
                    
                } label: {
                    AddLabelComponent(color: (Theme(rawValue: theme) ?? .blue).get2(), text: "Add Category")
                }
                .buttonStyle(.plain)
                
                ForEach(categories.sorted(by: {$0.name < $1.name})) { category in
                    CategoryEditComponent(category: category)
                }
                .padding(.horizontal, 15)
                
                // MARK: Bags editor
                Text("Bags")
                    .font(.title3).bold()
                    .foregroundStyle((Theme(rawValue: theme) ?? .blue).get1())
                    .padding(.horizontal, 30)
                    .padding(.vertical, 15)
                    .background((Theme(rawValue: theme) ?? .blue).get2())
                    .clipShape(UnevenRoundedRectangle(cornerRadii:
                            .init(topLeading: 10, bottomLeading: 0, bottomTrailing: 0, topTrailing: 10)))
                    .padding(.leading, 15)
                    .padding(.top, 20)
                
                Button {
                    modelContext.insert(Bag(name: "New Bag"))
                    
                } label: {
                    AddLabelComponent(color: ((Theme(rawValue: theme) ?? .blue).get2()), text: "Add Bag")
                }
                .buttonStyle(.plain)
                
                ForEach(bags.sorted(by: {$0.name < $1.name})) { bag in
                    BagEditComponent(bag: bag)
                }
                .padding(.horizontal, 15)
            }
            .padding(.bottom, 15)
        }
        .background((Theme(rawValue: theme) ?? .blue).get1())
        .tint((Theme(rawValue: theme) ?? .blue).get2())
    }
}
