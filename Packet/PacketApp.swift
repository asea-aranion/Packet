//
//  PacketApp.swift
//  Packet
//
//  Created by Leia Spagnola on 12/23/24.
//

import SwiftUI
import SwiftData

@main
struct PacketApp: App {
    
    var container: ModelContainer
    
    init() {
        do {
            container = try ModelContainer(for: PackingList.self, TemplateList.self)
        }
        catch {
            fatalError("Failed to initialize data container: \(error)")
        }
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(container)
    }
}
