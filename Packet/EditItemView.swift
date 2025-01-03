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
    
    @Query var categories: [Category]
    @Query var bags: [Bag]
    
    @Bindable var item: Item
    
    var duration: Int = 0
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
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
                
                // name field
                TextField("Name", text: $item.name)
                    .padding(12)
                    .textFieldStyle(.roundedBorder)
                    .background(.quinary)
                    .clipShape(RoundedRectangle(cornerRadius: 15))
                    .padding(.horizontal, 15)
                    .padding(.vertical, 10)
                
                Stepper("Quantity", value: $item.quantity)
                    .padding(.horizontal, 15)
                    .padding(.vertical, 10)
                
                Button {
                    item.quantity = duration
                } label: {
                    Text("Set to trip duration (\(duration) nights)")
                }
                
                .padding(10)
                .frame(maxWidth: .infinity)
                .background(.quinary)
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .padding(.horizontal, 15)
                .padding(.vertical, 10)
                
                GeometryReader { geometry in
                    HStack {
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
                        .frame(width: geometry.size.width * 0.45)
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
                        .frame(width: geometry.size.width * 0.45)
                        .background(.quinary)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                    }
                    .padding([.leading, .trailing], 15)
                }
                
                
                
            }
        }
    }
}
