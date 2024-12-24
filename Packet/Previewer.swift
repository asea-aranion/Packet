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
    let list: List
    
    init() throws {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        container = try ModelContainer(for: List.self, configurations: config)
        
        list = List()
        list.name = "Previewer List"
        
        container.mainContext.insert(list)
    }
}
