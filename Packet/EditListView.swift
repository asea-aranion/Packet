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
    
    @Query var categories: [Category]
    @Query var bags: [Bag]
    
    @Bindable var list: PackingList
    @State var selectedColor: Color = Color.blue
    @State var itemToEdit: Item?
    @State var categoryFilter: String = "Any"
    @State var bagFilter: String = "Any"
    
    @AppStorage("theme") var theme: Int = 0
    
    @Binding var path: NavigationPath
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                
                // edit list name
                TextField("Packing list name", text: $list.name)
                    .multilineTextAlignment(.center)
                    .textFieldStyle(.plain)
                    .font(.system(size: 24, weight: .bold))
                    .padding(5)
                    .background((Theme(rawValue: theme) ?? .blue).get1())
                    .clipShape(RoundedRectangle(cornerRadius: 6))
                    .foregroundStyle(Color(red: list.colorRed, green: list.colorGreen, blue: list.colorBlue))
                    .padding(15)
                    .background(Color(red: list.colorRed, green: list.colorGreen, blue: list.colorBlue))
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .padding(15)
                
                GeometryReader { geometry in
                    HStack(spacing: geometry.size.width * 0.1) {
                        // toggle active
                        Button {
                            withAnimation(.easeInOut(duration: 0.1)) {
                                list.active.toggle()
                            }
                        } label: {
                            Text(list.active ?
                                "\(Image(systemName: "checkmark")) Active" :
                                "\(Image(systemName: "xmark")) Inactive")
                                .bold()
                                .padding(5)
                                .frame(width: geometry.size.width * 0.35)
                                .background(list.active ?
                                            Color(red: list.colorRed, green: list.colorGreen, blue: list.colorBlue) :
                                            .clear)
                                .foregroundStyle(list.active ?
                                                 (Theme(rawValue: theme) ?? .blue).get1() :
                                                 Color(red: list.colorRed, green: list.colorGreen, blue: list.colorBlue))
                                .clipShape(RoundedRectangle(cornerRadius: 6))
                        }
                        .padding(.vertical, 15)
                        .frame(width: geometry.size.width * 0.45)
                        .background(.quinary)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                        
                        // edit list color
                        ColorPicker("\(Image(systemName: "paintbrush")) Color", selection: $selectedColor)
                            .onChange(of: selectedColor) {
                                list.colorRed = Double(selectedColor.resolve(in: environment).red)
                                list.colorGreen = Double(selectedColor.resolve(in: environment).green)
                                list.colorBlue = Double(selectedColor.resolve(in: environment).blue)
                            }
                            .padding(15)
                            .frame(width: geometry.size.width * 0.45)
                            .background(.quinary)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                    }
                }
                .frame(minHeight: 60)
                .padding(.horizontal, 15)
                .padding(.bottom, 15)
                
                // edit start date
                DatePicker("\(Image(systemName: "calendar")) Departure date", selection: $list.startDate, displayedComponents: .date)
                    .padding(15)
                    .background(.quinary)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .padding(.vertical, 10)
                    .padding(.horizontal, 15)
                
                // edit end date
                DatePicker("\(Image(systemName: "calendar")) Return date", selection: $list.endDate, displayedComponents: .date)
                    .padding(15)
                    .background(.quinary)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .padding(.vertical, 10)
                    .padding(.horizontal, 15)
                
                GeometryReader { geometry in
                    HStack(spacing: geometry.size.width * 0.1) {
                        
                        // duplicate button
                        Button {
                            modelContext.insert(PackingList.copy(from: list))
                            path = NavigationPath()
                            
                        } label: {
                            Text("\(Image(systemName: "square.on.square")) Duplicate")
                                .font(.body.bold())
                                .padding([.top, .bottom], 15)
                            
                                .frame(width: geometry.size.width * 0.45)
                                .foregroundStyle(Color(red: list.colorRed, green: list.colorGreen, blue: list.colorBlue))
                                .background(.quinary)
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                        }
                        .buttonStyle(.plain)
                        
                        // delete button
                        Button {
                            modelContext.delete(list)
                            path = NavigationPath()
                            
                        } label: {
                            Text("\(Image(systemName: "trash")) Delete")
                                .font(.body.bold())
                                .padding([.top, .bottom], 15)
                            
                                .frame(width: geometry.size.width * 0.45)
                                .foregroundStyle(.red)
                                .background(.quinary)
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                        }
                        .buttonStyle(.plain)
                        
                    }
                }
                .frame(minHeight: 60)
                .padding(.horizontal, 15)
                .padding(.top, 15)
                
                // view and edit list items
                Text("Items")
                    .foregroundStyle((Theme(rawValue: theme) ?? .blue).get1())
                    .font(.system(size: 20, weight: .bold))
                    .padding([.leading, .trailing], 30)
                    .padding([.top, .bottom], 15)
                    .background(Color(red: list.colorRed, green: list.colorGreen, blue: list.colorBlue))
                    .clipShape(UnevenRoundedRectangle(cornerRadii:
                            .init(topLeading: 10, bottomLeading: 0, bottomTrailing: 0, topTrailing: 10)))
                    .padding(.leading, 15)
                    .padding(.top, 20)
                
                Button {
                    let newItem = Item()
                    list.items?.append(newItem)
                    itemToEdit = newItem
                } label: {
                    VStack(alignment: .leading) {
                        Text("\(Image(systemName: "plus.circle")) Add Item")
                            .font(.system(size: 18, weight: .bold))
                        
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
                
                // item filters
                GeometryReader { geometry in
                    HStack(spacing: geometry.size.width * 0.1) {
                        // category picker
                        Picker("Filter by category", selection: $categoryFilter) {
                            Text("Any").tag("Any")
                            ForEach(categories) { category in
                                Text(category.name).tag(category.name)
                            }
                        }
                        .padding([.top, .bottom], 15)
                        .frame(width: geometry.size.width * 0.45)
                        .background(.quinary)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                        
                        // bag picker
                        Picker("Filter by bag", selection: $bagFilter) {
                            Text("Any").tag("Any")
                            ForEach(bags) { bag in
                                Text(bag.name).tag(bag.name)
                            }
                        }
                        .padding([.top, .bottom], 15)
                        .frame(width: geometry.size.width * 0.45)
                        .background(.quinary)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                    }
                }
                .frame(minHeight: 60)
                .padding([.leading, .trailing], 15)
                
                // items in list
                VStack(alignment: .leading) {
                    ForEach((list.items ?? [])
                        .filter({
                            (categoryFilter == "Any" || $0.category?.name ?? "Any" == categoryFilter)
                            && (bagFilter == "Any" || $0.bag?.name ?? "Any" == bagFilter)
                        })) { item in
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
            .padding(.bottom, 15)
        }
        .onAppear {
            selectedColor = Color(red: list.colorRed, green: list.colorGreen, blue: list.colorBlue)
        }
        .popover(item: $itemToEdit) { data in
            EditItemView(item: data)
        }
        .background((Theme(rawValue: theme) ?? .blue).get1())
        .tint(Color(red: list.colorRed, green: list.colorGreen, blue: list.colorBlue))
    }
}
