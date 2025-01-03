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
    @State var categoryFilter: Category? = nil
    @State var bagFilter: Bag? = nil
    @State var ignoreCategory: Bool = true
    @State var ignoreBag: Bool = true
    
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
                
                HStack(spacing: 15) {
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
                        .padding(.vertical, 10)
                        .padding(.horizontal, 20)
                        .background(list.active ?
                                    Color(red: list.colorRed, green: list.colorGreen, blue: list.colorBlue) :
                                .clear)
                        .foregroundStyle(list.active ?
                                         (Theme(rawValue: theme) ?? .blue).get1() :
                                            Color(red: list.colorRed, green: list.colorGreen, blue: list.colorBlue))
                        .clipShape(RoundedRectangle(cornerRadius: 6))
                    }
                    .frame(maxWidth: .infinity, minHeight: 60)
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
                        .frame(maxWidth: .infinity, minHeight: 60)
                        .background(.quinary)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                }
                .frame(minHeight: 60)
                .padding(.horizontal, 15)
                .padding(.bottom, 10)
                
                // edit start date
                DatePicker("\(Image(systemName: "calendar")) Departure date", selection: $list.startDate,
                           in: Date.distantPast...list.endDate, displayedComponents: .date)
                .padding(15)
                .background(.quinary)
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .padding(.bottom, 10)
                .padding(.horizontal, 15)
                
                // edit end date
                DatePicker("\(Image(systemName: "calendar")) Return date", selection: $list.endDate,
                           in: list.startDate...Date.distantFuture, displayedComponents: .date)
                .padding(15)
                .background(.quinary)
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .padding(.bottom, 10)
                .padding(.horizontal, 15)
                
                HStack(spacing: 15) {
                    
                    // duplicate button
                    Button {
                        modelContext.insert(PackingList.copy(from: list))
                        path = NavigationPath()
                        
                    } label: {
                        Text("\(Image(systemName: "square.on.square")) Duplicate")
                            .font(.body.bold())
                            .padding([.top, .bottom], 15)
                        
                            .frame(maxWidth: .infinity)
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
                        
                            .frame(maxWidth: .infinity)
                            .foregroundStyle(.red)
                            .background(.quinary)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                    }
                    .buttonStyle(.plain)
                    
                }
                
                .frame(minHeight: 60)
                .padding(.horizontal, 15)
                .padding(.bottom, 10)
                
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
                    HStack(spacing: 15) {
                        // category picker
                        Menu {
                            Button("Any") {
                                ignoreCategory = true
                            }
                            Button("(No category)") {
                                ignoreCategory = false
                                categoryFilter = nil
                            }
                            ForEach(categories) { category in
                                Button(category.name) {
                                    ignoreCategory = false
                                    categoryFilter = category
                                }
                            }
                        } label: {
                            Text("\(Image(systemName: "list.clipboard")) \(ignoreCategory ? "Any" : (categoryFilter?.name ?? "(No category)")) \(Image(systemName: "chevron.down"))")
                        }
                        .padding(.vertical, 20)
                        .frame(maxWidth: .infinity)
                        .background(.quinary)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                        
                        // bag picker
                        Menu {
                            Button("Any") {
                                ignoreBag = true
                            }
                            Button("(No bag)") {
                                ignoreBag = false
                                bagFilter = nil
                            }
                            ForEach(bags) { bag in
                                Button(bag.name) {
                                    ignoreBag = false
                                    bagFilter = bag
                                }
                            }
                        } label: {
                            Text("\(Image(systemName: "bag")) \(ignoreBag ? "Any" : (bagFilter?.name ?? "(No bag)")) \(Image(systemName: "chevron.down"))")
                        }
                        .padding(.vertical, 20)
                        .frame(maxWidth: .infinity)
                        .background(.quinary)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                    }
                
                .frame(minHeight: 60)
                .padding(.horizontal, 15)
                .padding(.bottom, 10)
                
                // items in list
                VStack(alignment: .leading) {
                    ForEach((list.items ?? [])
                        .filter({
                            (ignoreCategory || $0.category == categoryFilter)
                            && (ignoreBag || $0.bag == bagFilter)
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
            EditItemView(item: data, duration: Calendar.current.dateComponents([.day], from: Calendar.current.startOfDay(for: list.startDate), to: Calendar.current.startOfDay(for: list.endDate)).day ?? 0)
        }
        .background((Theme(rawValue: theme) ?? .blue).get1())
        .tint(Color(red: list.colorRed, green: list.colorGreen, blue: list.colorBlue))
    }
}
