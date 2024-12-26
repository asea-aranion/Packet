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
                
                // theme picker
                Text("Theme")
                    .font(.system(size: 20, weight: .bold))
                    .foregroundStyle(.white)
                    .padding([.leading, .trailing], 30)
                    .padding([.top, .bottom], 15)
                    .background((ColorScheme(rawValue: theme) ?? .blue).get2())
                    .clipShape(UnevenRoundedRectangle(cornerRadii:
                            .init(topLeading: 10, bottomLeading: 0, bottomTrailing: 0, topTrailing: 10)))
                    .padding(.leading, 15)
                    .padding(.top, 20)
                
                HStack {
                        ForEach(ColorScheme.allCases, id: \.self) { color in
                            Button {
                                UserDefaults.standard.set(color.rawValue, forKey: "theme")
                            } label: {
                                ZStack {
                                    Circle()
                                        .fill(color.get1())
                                    Circle()
                                        .trim(from: 0.375, to: 0.875)
                                        .fill(color.get2())
                                    if (theme == color.rawValue) {
                                        Circle()
                                            .stroke(Color.white, lineWidth: 4)
                                    }
                                }
                            }
                            .padding(10)
                        }
                }
                .padding([.leading, .trailing], 15)
                
                // category editor
                Text("Categories")
                    .font(.system(size: 20, weight: .bold))
                    .foregroundStyle(.white)
                    .padding([.leading, .trailing], 30)
                    .padding([.top, .bottom], 15)
                    .background((ColorScheme(rawValue: theme) ?? .blue).get2())
                    .clipShape(UnevenRoundedRectangle(cornerRadii:
                            .init(topLeading: 10, bottomLeading: 0, bottomTrailing: 0, topTrailing: 10)))
                    .padding(.leading, 15)
                    .padding(.top, 20)
                
                Button {
                    modelContext.insert(Category(name: "New Category"))
                } label: {
                    VStack(alignment: .leading) {
                        
                            Text("\(Image(systemName: "plus.circle")) Add Category")
                                .font(.system(size: 18, weight: .bold))
                        
                        RoundedRectangle(cornerRadius: 10)
                            .fill((ColorScheme(rawValue: theme) ?? .blue).get2())
                            .frame(height: 8)
                        
                    }
                    
                    .frame(height: 60)
                    .padding(.top, 10)
                    .padding([.leading, .trailing], 15)
                }
                .buttonStyle(.plain)
                .foregroundStyle((ColorScheme(rawValue: theme) ?? .blue).get2())
                
                ForEach(categories.sorted(by: {$0.name < $1.name})) { category in
                    CategoryEditComponent(category: category)
                }
                .padding([.leading, .trailing], 15)
            }
        }
        .background((ColorScheme(rawValue: theme) ?? .blue).get1())
    }
}
