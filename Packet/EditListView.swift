//
//  EditListView.swift
//  Packet
//
//  Created by Leia Spagnola on 12/23/24.
//

import SwiftUI
import SwiftData

struct EditListView: View {
    
    @Environment(\.self) var environment
    @Environment(\.modelContext) var modelContext
    
    @State var list: List
    @State var selectedColor: Color = Color.blue
    @State var itemToEdit: Item?
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                
                Button {
                    modelContext.insert(List.copy(from: list))
                    
                } label: {
                    Text("Duplicate")
                        .foregroundStyle(Color(red: list.colorRed, green: list.colorGreen, blue: list.colorBlue))
                        .background(.quinary)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                        .padding([.leading, .trailing], 15)
                }
                .buttonStyle(.plain)
                
                // edit list name
                TextField("", text: $list.name)
                    .multilineTextAlignment(.center)
                    .font(.system(size: 24, weight: .bold))
                    .padding(15)
                    .foregroundStyle(Color(red: list.colorRed, green: list.colorGreen, blue: list.colorBlue))
                    .textFieldStyle(.roundedBorder)
                    .background(Color(red: list.colorRed, green: list.colorGreen, blue: list.colorBlue))
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .padding(10)
                
                // edit list color
                ColorPicker("Accent color", selection: $selectedColor)
                    .onChange(of: selectedColor) {
                        list.colorRed = Double(selectedColor.resolve(in: environment).red)
                        list.colorGreen = Double(selectedColor.resolve(in: environment).green)
                        list.colorBlue = Double(selectedColor.resolve(in: environment).blue)
                    }
                    .padding(10)
                
                // view and edit list items
                Text("Items")
                    .font(.system(size: 18, weight: .bold))
                    .padding(.leading, 15)
                    .padding(.top, 10)
                
                Button {
                    let newItem = Item()
                    list.items?.append(newItem)
                    itemToEdit = newItem
                } label: {
                    VStack(alignment: .leading) {
                        HStack {
                            Image(systemName: "plus.circle")
                            Text("Add Item")
                                .font(.system(size: 18, weight: .bold))
                            
                        }
                        
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color(red: list.colorRed, green: list.colorGreen, blue: list.colorBlue))
                            .frame(height: 8)
                        
                    }
                    
                    .frame(height: 60)
                    .padding(.top, 10)
                    .padding([.leading, .trailing], 15)
                }
                .buttonStyle(.plain)
                .foregroundStyle(Color(red: list.colorRed, green: list.colorGreen, blue: list.colorBlue))
                
                // items in list
                LazyVStack(alignment: .leading) {
                    ForEach(list.items ?? []) { item in
                        Button {
                            itemToEdit = item
                        } label: {
                            ItemComponent(item: item)
                        }
                        .buttonStyle(.plain)
                        .padding(.top, 10)
                        .padding([.leading, .trailing], 15)
                    }
                }
                
            }
        }
        .onAppear {
            selectedColor = Color(red: list.colorRed, green: list.colorGreen, blue: list.colorBlue)
        }
        .popover(item: $itemToEdit) { data in
            EditItemView(item: data)
        }
    }
}
