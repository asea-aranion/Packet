//
//  EditTemplateItemView.swift
//  Packet
//
//  Created by Leia Spagnola on 1/7/25.
//

import SwiftUI
import SwiftData

struct EditTemplateItemView: View {
    
    @Environment(\.dismiss) var dismiss
    
    @Query var categories: [Category]
    @Query var bags: [Bag]
    
    @Bindable var list: TemplateList
    @Bindable var item: Item
    
    @State var showDeleteConf: Bool = false
    
    var body: some View {
        VStack(alignment: .center) {
            
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
            
            Button {
                showDeleteConf = true
            } label: {
                Text("\(Image(systemName: "trash")) Delete")
                    .bold()
            }
            .foregroundStyle(.red)
            .padding(.vertical, 15)
            .padding(.horizontal, 20)
            .background(.quinary)
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .padding(.horizontal, 15)
            .padding(.top, 10)
            
        }
        .padding(.top, 10)
        .confirmationDialog("Delete this item?", isPresented: $showDeleteConf, actions: {
            Button("Delete", role: .destructive) {
                list.items?.removeAll(where: {$0.persistentModelID == item.persistentModelID})
                dismiss()
            }
        })
    }
}
