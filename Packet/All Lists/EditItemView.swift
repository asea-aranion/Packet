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
    @State var names: Set<String> = [] // will be filled with unique names of items in other lists and templates
    @State var namesPopulated: Bool = false // condition for displaying set of names in UI
    
    @Binding var showingNames: Bool // when set by user input, begins name population and increases sheet height
    
    var duration: Int = 0
    
    var body: some View {
        VStack {
            
            HStack(alignment: .top) {
                
                // MARK: Quantity editor
                VStack(spacing: 0) {
                    Button("+") {
                        item.quantity += 1
                    }
                    .font(.system(size: 24, weight: .bold))
                    .padding(.bottom, 10)
                    .accessibilityHint("Adds 1 to quantity")
                    Text(String(item.quantity))
                        .bold()
                        .frame(minWidth: 40, minHeight: 40)
                        .background(.quinary)
                        .clipShape(Circle())
                    Button("-") {
                        item.quantity -= 1
                    }
                    .font(.system(size: 24, weight: .bold))
                    .padding(.top, 10)
                    .accessibilityHint("Subtracts 1 from quantity")
                    .disabled(item.quantity == 1)
                }
                .padding(.trailing, 5)
                
                // MARK: Item name editor
                VStack(alignment: .leading, spacing: 0) {
                    
                    TextField("Item name", text: $item.name)
                        .multilineTextAlignment(.leading)
                        .padding(.top, 5)
                    
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color(red: list.colorRed, green: list.colorGreen, blue: list.colorBlue))
                        .frame(height: 5)
                        .frame(maxWidth: .infinity)
                        .padding(0)
                    
                    // if user has pressed button to show autofill options
                    if (showingNames) {
                        // MARK: Item name autofill option list
                        ScrollView {
                            // checks that names have been populated to avoid unnecessary UI updates
                            if (namesPopulated) {
                                ForEach(names.filter({
                                    // shows all names if no starting text has been entered as this item's name
                                    item.name.isEmpty || $0.localizedCaseInsensitiveContains(item.name)
                                }), id: \.self) { option in
                                    Button {
                                        // autofills item name with selection and closes name list
                                        item.name = option
                                        withAnimation {
                                            showingNames = false
                                        }
                                    // only tapping the text selects the name, to prevent accidental selection
                                    // while scrolling
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
                        }
                        .transition(.move(edge: .top).combined(with: .opacity))
                        .onAppear {
                            // checks to ensure names are only populated once
                            if (!namesPopulated) {
                                items.forEach {
                                    names.insert($0.name)
                                }
                                
                                // removes all elements in names that are in this list,
                                // as the user is unlikely to add duplicate items in the same list
                                list.subtractItemNames(&names)
                                
                                // removes the empty string (the default new item name) if it was added,
                                // as the user is unlikely to intentionally add a blank name
                                names.remove("")
                                
                                // signals that population is complete and ForEach can be shown
                                namesPopulated = true
                            }
                        }
                        .frame(maxHeight: 140)
                        .padding(.top, 8)
                    }
                    
                }
                // aligns textfield with quantity editor
                .padding(.top, 40)
                
                // MARK: Button to show name list
                Button {
                    withAnimation {
                        showingNames.toggle()
                    }
                } label: {
                    Image(systemName: "chevron.down.circle")
                        .font(.system(size: 28, weight: .bold))
                        .padding(.horizontal, 10)
                        .foregroundStyle(Color(red: list.colorRed, green: list.colorGreen, blue: list.colorBlue))
                        .rotationEffect(Angle(degrees: showingNames ? -90 : 0))
                        .animation(.easeInOut, value: showingNames)
                }
                .padding(.top, 40)
                
            }
            .padding(.horizontal, 15)
            .padding(.bottom, 5)
            
            // MARK: Button to set item quantity to number of nights of trip
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
                // MARK: Menu picker for item category
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
                
                // MARK: Menu picker for item bag
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
            
            // MARK: Button to delete item
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
        // item delete confirmation
        .confirmationDialog("Delete this item?", isPresented: $showDeleteConf, actions: {
            Button("Delete", role: .destructive) {
                list.items?.removeAll(where: {$0.persistentModelID == item.persistentModelID})
                dismiss()
            }
        })
    }
    
}
