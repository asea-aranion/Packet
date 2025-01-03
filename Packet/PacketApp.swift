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
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: PackingList.self)
        .modelContainer(for: Bag.self)
        .modelContainer(for: Category.self)
    }
}
