//
//  TemplatesView.swift
//  Packet
//
//  Created by Leia Spagnola on 1/6/25.
//

import SwiftUI
import SwiftData

struct TemplatesView: View {
    
    @Environment(\.modelContext) var modelContext
    
    @Query var templates: [TemplateList]
    
    @State var path: NavigationPath = NavigationPath()
    
    @AppStorage("theme") var theme = 0
    
    var body: some View {
        NavigationStack(path: $path) {
            ScrollView {
                VStack {
                    Button {
                        let newTemplate = TemplateList()
                        modelContext.insert(newTemplate)
                        path.append(newTemplate)
                    } label: {
                        AddLabelComponent(color: ((Theme(rawValue: theme) ?? .blue).get2()), text: "Add Template")
                    }
                    .buttonStyle(.plain)
                    
                    ForEach(templates) { template in
                        TemplateComponent(list: template, path: $path)
                    }
                }
            }
            .navigationTitle("Templates")
            .navigationDestination(for: TemplateList.self) { list in
                EditTemplateView(list: list, path: $path)
            }
            .background((Theme(rawValue: theme) ?? .blue).get1())
        }
    }
}
