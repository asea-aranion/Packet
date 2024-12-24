//
//  ContentView.swift
//  Packet
//
//  Created by Leia Spagnola on 12/23/24.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    
    @Query var userInfo: [UserInfo]
    
    var body: some View {
        ListsView(userInfo: userInfo.isEmpty ? UserInfo() : userInfo[0])
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
