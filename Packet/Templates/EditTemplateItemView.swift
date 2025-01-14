//
//  EditTemplateItemView.swift
//  Packet
//
//  Created by Leia Spagnola on 1/7/25.
//

import SwiftUI
import SwiftData

struct EditTemplateItemView: View {
    
    @Query var categories: [Category]
    @Query var bags: [Bag]
    
    //var listColor: Color
    
    @Bindable var item: Item
    
    var body: some View {
        VStack(alignment: .leading) {
            
            // name field
            HStack {
                
                VStack(spacing: 0) {
                    Button("+") {
                        item.quantity += 1
                    }
                    .font(.system(size: 24, weight: .bold))
                    .accessibilityHint("Adds 1 to quantity")
                    Text(String(item.quantity))
                        .bold()
                        .padding(15)
                        .background(.quinary)
                        .clipShape(Circle())
                    Button("-") {
                        item.quantity -= 1
                    }
                    .font(.system(size: 24, weight: .bold))
                    .accessibilityHint("Subtracts 1 from quantity")
                    .disabled(item.quantity == 1)
                }
                .padding(.trailing, 5)
                
                TextField("Name", text: $item.name)
                    .padding(12)
                    .textFieldStyle(.roundedBorder)
                    .background(.quinary)
                    .clipShape(RoundedRectangle(cornerRadius: 15))
                    
            }
            .padding(.horizontal, 15)
            .padding(.vertical, 10)
            
            HStack(spacing: 15) {
                    // category picker
                    Menu {
                        Button {
                            item.category = nil
                        } label: {
                            Text("(No category)")
                        }
                        ForEach(categories) { category in
                            Button {
                                
                                item.category = category
                                
                            } label: {
                                Text(category.name)
                            }
                        }
                    } label: {
                        HStack {
                            Text(item.category?.name ?? "(No category)")
                            Image(systemName: "chevron.down")
                        }
                    }
                    .padding(15)
                    .frame(maxWidth: .infinity)
                    .background(.quinary)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    
                    // bag picker
                    Menu {
                        Button {
                            item.bag = nil
                        } label: {
                            Text("(No bag)")
                        }
                        ForEach(bags) { bag in
                            Button {
                                item.bag = bag
                            } label: {
                                Text(bag.name)
                            }
                        }
                    } label: {
                        HStack {
                            Text(item.bag?.name ?? "(No bag)")
                            Image(systemName: "chevron.down")
                        }
                    }
                    .padding(15)
                    .frame(maxWidth: .infinity)
                    .background(.quinary)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                }
                .padding(.horizontal, 15)
            
        }
        .padding(.top, 10)
        //.tint(listColor)
    }
}
