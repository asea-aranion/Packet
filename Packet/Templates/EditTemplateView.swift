//
//  EditTemplateView.swift
//  Packet
//
//  Created by Leia Spagnola on 1/6/25.
//

import SwiftUI
import SwiftData

struct EditTemplateView: View {
    
    @Environment(\.self) var environment
    @Environment(\.modelContext) var modelContext
    
    @Query var categories: [Category]
    @Query var bags: [Bag]
    
    @Bindable var list: TemplateList
    
    @State var categoryFilter: Category?
    @State var bagFilter: Bag?
    @State var ignoreCategory: Bool = true
    @State var ignoreBag: Bool = true
    @State var selectedColor: Color = .blue
    @State var itemToEdit: Item?
    
    @AppStorage("theme") var theme = 0
    
    @Binding var path: NavigationPath
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                
                // edit template name
                TextField("Template name", text: $list.name)
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
                    .padding(.horizontal, 15)
                    .padding(.bottom, 10)
                
                HStack(spacing: 15) {
                    
                    // duplicate button
                    Button {
                        modelContext.insert(TemplateList.init(from: list))
                        path = NavigationPath()
                        
                    } label: {
                        Text("\(Image(systemName: "square.on.square")) Duplicate")
                            .font(.body.bold())
                            .padding(.vertical, 15)
                        
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
                            .padding(.vertical, 15)
                        
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
                    .padding(.horizontal, 30)
                    .padding(.vertical, 15)
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
                    .padding(.horizontal, 15)
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
                            .padding(.vertical, 5)
                            .padding(.horizontal, 15)
                        }
                }
            }
        }
        .onAppear {
            selectedColor = Color(red: list.colorRed, green: list.colorGreen, blue: list.colorBlue)
        }
        .sheet(item: $itemToEdit) { data in
            EditTemplateItemView(item: data)
            .presentationDetents([.fraction(0.4)])
        }
        .background((Theme(rawValue: theme) ?? .blue).get1())
        .tint(Color(red: list.colorRed, green: list.colorGreen, blue: list.colorBlue))
        .scrollDismissesKeyboard(.immediately)
    }
}
