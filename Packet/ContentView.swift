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
    
    /*
     determines whether to add starter data on launch by
     1) getting value from iCloud
     2) getting locally stored value
     3) adds data by default if neither has been initialized (startersAdded = false)
     */
    @State var startersAdded = NSUbiquitousKeyValueStore.default.object(forKey: "startersAdded") as? Bool ?? UserDefaults.standard.bool(forKey: "startersAdded")
    
    @AppStorage("theme") var theme: Int = 0
    
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
            
            // add starter templates, categories, and bags if not already added
            if (!startersAdded) {
                NSUbiquitousKeyValueStore.default.set(true, forKey: "startersAdded")
                UserDefaults.standard.set(true, forKey: "startersAdded")
                
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
                        Item(name: "Sunglasses", quantity: 1, bag: personal, category: accessories),
                        Item(name: "Hat", quantity: 1, bag: personal, category: accessories)
                    ]
                )
                
                let ski = TemplateList(
                    name: "Ski Vacation",
                    colorRed: 130 / 255,
                    colorGreen: 108 / 255,
                    colorBlue: 240 / 255,
                    items: [
                        Item(name: "Snow Pants", quantity: 5, bag: checked, category: clothing),
                        Item(name: "Sweaters", quantity: 4, bag: checked, category: clothing),
                        Item(name: "Turtlenecks", quantity: 2, bag: carry, category: accessories),
                        Item(name: "Snow Jacket", quantity: 1, bag: checked, category: clothing),
                        Item(name: "Snow Boots", quantity: 1, bag: checked, category: clothing),
                        Item(name: "Sunblock", quantity: 1, bag: checked, category: toiletries),
                        Item(name: "Ski Goggles", quantity: 1, bag: checked, category: accessories),
                        Item(name: "Gloves", quantity: 2, bag: checked, category: accessories),
                        Item(name: "Warm Socks", quantity: 5, bag: carry, category: accessories),
                        Item(name: "Base Layers", quantity: 5, bag: carry, category: accessories),
                        Item(name: "Scarf", quantity: 1, bag: checked, category: accessories)
                    ]
                )
                
                modelContext.insert(beach)
                modelContext.insert(ski)
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
