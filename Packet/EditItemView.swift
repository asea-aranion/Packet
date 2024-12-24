//
//  EditItemView.swift
//  Packet
//
//  Created by Leia Spagnola on 12/23/24.
//

import SwiftUI
import SwiftData

struct EditItemView: View {
    
    @Environment(\.dismiss) var dismiss
    
    @State var item: Item
    
    var body: some View {
        ScrollView {
            VStack {
                HStack {
                    Spacer()
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "xmark.circle")
                            .font(.system(size: 40))
                    }
                }
                .padding(.top, 20)
                .padding(.trailing, 24)
                TextField("Name", text: $item.name)
                    .padding(12)
                    .textFieldStyle(.roundedBorder)
                    .background(.quinary)
                    .clipShape(RoundedRectangle(cornerRadius: 15))
                    .padding([.leading, .trailing], 15)
                    .padding([.top, .bottom], 10)
            }
        }
    }
}
