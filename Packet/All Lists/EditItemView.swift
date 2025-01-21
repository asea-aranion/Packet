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
    @Query var items: [Item]
    
    @Bindable var list: PackingList
    @Bindable var item: Item
    
    @State var showDeleteConf: Bool = false
    @State var names: Set<String> = []
    
    @Binding var showingNames: Bool
    
    var duration: Int = 0
    
    var body: some View {
        VStack {
            
            HStack(alignment: .top) {
                
                // quantity editor
                VStack(spacing: 0) {
                    Button("+") {
                        item.quantity += 1
                    }
                    .font(.system(size: 24, weight: .bold))
                    .frame(height: 30)
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
                    .frame(height: 30)
                    .accessibilityHint("Subtracts 1 from quantity")
                    .disabled(item.quantity == 1)
                }
                .padding(.trailing, 5)
                
                // name editor
                VStack(alignment: .leading, spacing: 0) {
                    
                    TextField("Item name", text: $item.name)
                        .multilineTextAlignment(.leading)
                        .padding(.top, 5)
                    
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color(red: list.colorRed, green: list.colorGreen, blue: list.colorBlue))
                        .frame(height: 5)
                        .frame(maxWidth: .infinity)
                        .padding(0)
                    
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
                                
                            }
                            .padding(.leading, 15)
                            .padding(.vertical, 10)
                            .frame(maxWidth: .infinity)
                            .background(.quinary)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                        }
                    }
                    .frame(maxHeight: showingNames ? 140 : 0)
                    .padding(.top, 8)
                    
                }
                .padding(.top, 40)
                
                // show names button
                Button {
                    withAnimation(.easeInOut) {
                        showingNames.toggle()
                    }
                } label: {
                    Image(systemName: "chevron.down.circle")
                        .font(.system(size: 28, weight: .bold))
                        .padding(.horizontal, 10)
                        .foregroundStyle(Color(red: list.colorRed, green: list.colorGreen, blue: list.colorBlue))
                        .rotationEffect(Angle(degrees: showingNames ? -90 : 0))
                }
                .padding(.top, 40)
                
            }
            .padding(.horizontal, 15)
            .padding(.bottom, 5)
            
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
            
            // delete with confirmation button
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
        .onAppear {
            items.forEach {
                names.insert($0.name)
            }
            
            list.subtractItemNames(&names)
            
            names.remove("")
        }
        .confirmationDialog("Delete this item?", isPresented: $showDeleteConf, actions: {
            Button("Delete", role: .destructive) {
                list.items?.removeAll(where: {$0.persistentModelID == item.persistentModelID})
                dismiss()
            }
        })
    }
    
}
