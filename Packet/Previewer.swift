//
//  Previewer.swift
//  Packet
//
//  Created by Leia Spagnola on 12/23/24.
//

import SwiftData

@MainActor
struct Previewer {
    let container: ModelContainer
    let list: PackingList
    
    init() throws {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        container = try ModelContainer(for: PackingList.self, configurations: config)
        
        list = PackingList()
        list.name = "Previewer List"
        
        let category = Category(name: "New category")
        let bag = Bag(name: "Carry-on")
        
        container.mainContext.insert(list)
        container.mainContext.insert(category)
        container.mainContext.insert(bag)
    }
}
