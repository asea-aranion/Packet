//
//  ContentView.swift
//  Packet
//
//  Created by Leia Spagnola on 12/23/24.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    
    @Environment(\.modelContext) var modelContext
    
    @Query var lists: [PackingList]
    @Query var templates: [TemplateList]
    
    @State var selectedTab = 2
    
    @AppStorage("theme") var theme: Int = 0
    @AppStorage("startersAdded") var startersAdded: Bool = false
    
    var body: some View {
        TabView(selection: $selectedTab) {
            Tab(value: 1) {
                ActiveListView()
            } label: {
                Image(systemName: "checklist")
                Text("Active Lists")
            }
            
            Tab(value: 2) {
                ListsView()
            } label: {
                Image(systemName: "archivebox.fill")
                Text("All Lists")
            }
            
            Tab(value: 3) {
                TemplatesView()
            } label: {
                Image(systemName: "bookmark.fill")
                Text("Templates")
            }
            
            Tab(value: 4) {
                PreferencesView()
            } label: {
                Image(systemName: "person.fill")
                Text("Preferences")
            }
        }
        .onAppear {
            
            if (!startersAdded) {
                startersAdded = true
                
                let clothing = Category(name: "Clothing")
                modelContext.insert(clothing)
                
                let toiletries = Category(name: "Toiletries")
                modelContext.insert(toiletries)
                
                let accessories = Category(name: "Accessories")
                modelContext.insert(accessories)
                
                let checked = Bag(name: "Checked Bag")
                modelContext.insert(checked)
                
                let carry = Bag(name: "Carry-on")
                modelContext.insert(carry)
                
                let personal = Bag(name: "Personal Bag")
                modelContext.insert(personal)
                
                let beach = TemplateList(
                    name: "Beach Vacation",
                    colorRed: 227 / 255,
                    colorGreen: 194 / 255,
                    colorBlue: 89 / 255,
                    items: [
                        Item(name: "T-shirts", quantity: 5, bag: carry, category: clothing),
                        Item(name: "Shorts", quantity: 5, bag: carry, category: clothing),
                        Item(name: "Swimsuits", quantity: 2, bag: carry, category: clothing),
                        Item(name: "Flip-flops", quantity: 1, bag: carry, category: clothing),
                        Item(name: "Sunblock", quantity: 1, bag: checked, category: toiletries),
                        Item(name: "Sunglasses", quantity: 1, bag: personal, category: accessories)
                    ]
                )
                
                modelContext.insert(beach)
            }
        }
        .toolbarBackground((Theme(rawValue: theme) ?? .blue).get1(), for: .tabBar)
        .toolbarBackgroundVisibility(.visible, for: .tabBar)
        .tabViewStyle(.sidebarAdaptable)
        .tint((Theme(rawValue: theme) ?? .blue).get2())
    }
}

#Preview {
    do {
        let previewer = try Previewer()
        
        return ContentView()
            .modelContainer(previewer.container)
    } catch {
        return Text("Failed to create preview: \(error.localizedDescription)")
    }
}
