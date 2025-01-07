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
