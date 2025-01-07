//
//  EditTemplateView.swift
//  Packet
//
//  Created by Leia Spagnola on 1/6/25.
//

import SwiftUI

struct EditTemplateView: View {
    
    @Bindable var list: TemplateList
    
    @AppStorage("theme") var theme = 0
    
    @Binding var path: NavigationPath
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                
                // edit template name
                TextField("Packing list name", text: $list.name)
                    .multilineTextAlignment(.center)
                    .textFieldStyle(.plain)
                    .font(.system(size: 24, weight: .bold))
                    .padding(5)
                    .background((Theme(rawValue: theme) ?? .blue).get1())
                    .clipShape(RoundedRectangle(cornerRadius: 6))
                    .foregroundStyle((Theme(rawValue: theme) ?? .blue).get2())
                    .padding(15)
                    .background((Theme(rawValue: theme) ?? .blue).get2())
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .padding(15)
            }
        }
    }
}
