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
    
    @Query var lists: [PackingList]
    @Query var categories: [Category]
    @Query var bags: [Bag]
    
    @State var showDeleteConf: Bool = false
    @State var names: Set<String> = []
    @Binding var showingNames: Bool
    
    @Bindable var list: PackingList
    @Bindable var item: Item
    
    var duration: Int = 0
    
    var body: some View {
        VStack {
            
            HStack {
                
                // quantity editor
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
                
                // name editor
                VStack(alignment: .leading, spacing: 0) {
                    if (showingNames) {
                        TextField("Category name", text: $item.name)
                            .multilineTextAlignment(.leading)
                            .padding(.top, 5)
                    }
                    else {
                        Text(item.name)
                            .multilineTextAlignment(.leading)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.top, 6)
                    }
                    
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color(red: list.colorRed, green: list.colorGreen, blue: list.colorBlue))
                        .frame(height: 5)
                        .frame(maxWidth: showingNames ? 300 : 0)
                        .padding(0)
                    
                }
                
                if (showingNames) {
                    Button {
                        withAnimation(.easeInOut) {
                            showingNames = false
                        }
                    } label: {
                        Image(systemName: "checkmark")
                            .font(.system(size: 20, weight: .heavy))
                            .padding(.horizontal, 15)
                            .foregroundStyle(Color(red: list.colorRed, green: list.colorGreen, blue: list.colorBlue))
                    }
                }
                else {
                    Button("Edit") {
                        withAnimation(.easeInOut) {
                            showingNames = true
                            
                        }
                    }
                    .bold()
                    .padding(.vertical, 5)
                    .padding(.horizontal, 20)
                    .background(.quaternary)
                    .clipShape(Capsule())
                    .foregroundStyle(Color(red: list.colorRed, green: list.colorGreen, blue: list.colorBlue))
                    .padding(.trailing, 10)
                }
                
            }
            .padding(.horizontal, 15)
            .padding(.bottom, 5)
            
            // name options/autofill
            ScrollView {
                ForEach(names.filter({
                    item.name.isEmpty || $0.localizedCaseInsensitiveContains(item.name)
                }), id: \.self) { option in
                    Button {
                        item.name = option
                        withAnimation(.easeInOut) {
                            showingNames = false
                        }
                    } label: {
                        Text(option)
                            .padding(.leading, 15)
                            .padding(.vertical, 10)
                            .frame(maxWidth: .infinity)
                            .background(.quinary)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                    }
                    
                }
                .padding(.trailing, 5)
            }
            .frame(maxHeight: showingNames ? 150 : 0)
            .padding(.leading, 50)
            .padding(.bottom, 5)
            .padding(.trailing, 15)
            
            // quantity autoset
            Button {
                item.quantity = duration
            } label: {
                Text("Set quantity to duration (\(duration) nights)")
            }
            
            .padding(10)
            .frame(maxWidth: .infinity)
            .background(.quinary)
            .clipShape(RoundedRectangle(cornerRadius: 10))
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
        .onAppear {
            lists.forEach { packingList in
                names.formUnion(packingList.uniqueItemNames())
            }
        }
    }
    
}
