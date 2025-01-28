//
//  GroupPickerComponent.swift
//  Packet
//
//  Created by Leia Spagnola on 1/22/25.
//

import SwiftUI

struct GroupPickerComponent: View {
    
    @AppStorage("theme") var theme: Int = 0
    
    @Binding var groupByCategory: Bool
    
    var body: some View {
        HStack {
            Text("Group by")
                .bold()
                .padding(.trailing, 5)
            GeometryReader { geo in
                ZStack(alignment: .init(horizontal: .leading, vertical: .bottom)) {
                    // Colored background indicator
                    RoundedRectangle(cornerRadius: 10)
                        .fill((Theme(rawValue: theme) ?? .blue).get2())
                        .padding(5)
                        .frame(width: geo.size.width / 2, height: geo.size.height)
                        .offset(x: groupByCategory ? 0 : geo.size.width / 2)
                    HStack(spacing: 0) {
                        // Button to group by category
                        Button {
                            withAnimation(.easeInOut) {
                                groupByCategory = true
                            }
                        } label: {
                            Text("Category")
                                .bold()
                                .frame(width: geo.size.width / 2 - 0.5, height: geo.size.height)
                        }
                        // Separator
                        RoundedRectangle(cornerRadius: 10)
                            .fill(.separator)
                            .padding(.vertical, 12)
                            .frame(width: 1, height: geo.size.height)
                        // Button to group by bag
                        Button {
                            withAnimation(.easeInOut) {
                                groupByCategory = false
                            }
                        } label: {
                            Text("Bag")
                                .bold()
                                .frame(width: geo.size.width / 2 - 0.5, height: geo.size.height)
                        }
                    }
                }
            }
            .background(.quinary)
            .clipShape(RoundedRectangle(cornerRadius: 10))
        }
        .frame(height: 45)
        .buttonStyle(.plain)
    }
}
