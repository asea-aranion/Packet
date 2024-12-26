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
    
    @State var selectedTab = 2
    
    var body: some View {
        TabView(selection: $selectedTab) {
            Tab(value: 1) {
                
            } label: {
                Image(systemName: "checklist")
                Text("Active List")
            }
            
            Tab(value: 2) {
                ListsView()
            } label: {
                Image(systemName: "archivebox.fill")
                Text("All Lists")
            }
            
            Tab(value: 3) {
                PreferencesView()
            } label: {
                Image(systemName: "person.fill")
                Text("Preferences")
            }
        }
        .tabViewStyle(.sidebarAdaptable)
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
