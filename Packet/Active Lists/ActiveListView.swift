//
//  ActiveListView.swift
//  Packet
//
//  Created by Leia Spagnola on 12/29/24.
//

import SwiftUI
import SwiftData

struct ActiveListView: View {
    
    @Query(filter: #Predicate<PackingList> {
        list in list.active
    }, sort: \PackingList.startDate, order: .reverse) var activeLists: [PackingList]
    @Query var bags: [Bag]
    @Query var categories: [Category]
    
    @State var activeList: PackingList?
    @State var groupByCategory: Bool = true
    @State var itemToEdit: Item?
    @State var searchText: String = ""
    @State var itemEditShowingNames: Bool = false
    
    @AppStorage("theme") var theme: Int = 0
    
    @FocusState var searchFocused: Bool
    
    var body: some View {
        
            VStack {
                
                // if there are no active lists
                if (activeLists.isEmpty) {
                    VStack {
                        Image(systemName: "xmark.circle")
                            .font(.system(size: 48, weight: .bold))
                            .foregroundStyle((Theme(rawValue: theme) ?? .blue).get2())
                            .padding(.bottom, 20)
                        Text("No active lists")
                            .font(.system(size: 24, weight: .bold))
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    
                }
                else {
                    // active list selector
                    HStack {
                        Spacer()
                        Menu {
                            ForEach(activeLists) { list in
                                Button(list.name) {
                                    activeList?.activeSelected = false
                                    activeList = list
                                    activeList?.activeSelected = true
                                }
                            }
                        } label: {
                            Image(systemName: "chevron.down.circle")
                                .font(.system(size: 24, weight: .bold))
                                .foregroundStyle((Theme(rawValue: theme) ?? .blue).get2())
                        }
                    }
                    .padding(.horizontal, 15)
                    
                    // if no active list is selected
                    if (activeList == nil) {
                        VStack {
                            Image(systemName: "chevron.up.forward.2")
                                .font(.system(size: 48, weight: .bold))
                                .foregroundStyle((Theme(rawValue: theme) ?? .blue).get2())
                                .padding(.bottom, 20)
                            Text("No list selected")
                                .font(.system(size: 24, weight: .bold))
                        }
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        
                    }
                    else {
                        
                        ScrollView {
                            VStack(alignment: .leading, spacing: 0) {
                                
                                // title
                                HStack {
                                    Text(activeList?.name ?? "")
                                        .font(.system(size: 20, weight: .bold))
                                    Spacer()
                                    VStack {
                                        Text(String((activeList?.items ?? [Item]())
                                            .count(where: { item in
                                                !item.checked
                                            })
                                        ))
                                        .animation(.linear)
                                        Text("incomplete")
                                    }
                                    
                                }
                                .foregroundStyle((Theme(rawValue: theme) ?? .blue).get1())
                                .padding(.horizontal, 30)
                                .padding(.vertical, 15)
                                .background(Color(red: activeList?.colorRed ?? 0, green: activeList?.colorGreen ?? 0, blue: activeList?.colorBlue ?? 0))
                                .clipShape(UnevenRoundedRectangle(cornerRadii:
                                        .init(topLeading: 10, bottomLeading: 0, bottomTrailing: 0, topTrailing: 10)))
                                .padding(.top, 20)
                                
                                // group by picker
                                Picker("Group by", selection: $groupByCategory) {
                                    Text("Category").tag(true)
                                    Text("Bag").tag(false)
                                }
                                .pickerStyle(.segmented)
                                .padding(.vertical, 10)
                                
                                // search items
                                HStack {
                                    Image(systemName: "magnifyingglass")
                                        .foregroundStyle(Color(red: activeList?.colorRed ?? 0, green: activeList?.colorGreen ?? 0, blue: activeList?.colorBlue ?? 0))
                                    TextField("Filter items by name", text: $searchText)
                                        .focused($searchFocused)
                                        
                                        
                                    Button {
                                        searchText = ""
                                        searchFocused = false
                                    } label: {
                                        Image(systemName: "xmark.circle.fill")
                                            .font(.system(size: 20))
                                            .foregroundStyle(.gray)
                                    }
                                }
                                    .padding(10)
                                    .background(.quinary)
                                    .clipShape(RoundedRectangle(cornerRadius: 10))
                                    .padding(.vertical, 5)
                                
                                // items
                                
                                // category grouping
                                if (groupByCategory) {
                                    ForEach(categories.filter({
                                        activeList?.withNameHasCategory(category: $0, term: searchText) ?? false
                                    } )) { group in
                                        
                                        Text(group.name)
                                            .font(.system(size: 20, weight: .bold))
                                            .foregroundStyle((Theme(rawValue: theme) ?? .blue).get1())
                                            .padding(.horizontal, 30)
                                            .padding(.vertical, 15)
                                            .background(Color(red: activeList?.colorRed ?? 0, green: activeList?.colorGreen ?? 0, blue: activeList?.colorBlue ?? 0))
                                            .clipShape(UnevenRoundedRectangle(cornerRadii:
                                                    .init(topLeading: 10, bottomLeading: 0, bottomTrailing: 0, topTrailing: 10)))
                                            .padding(.top, 20)
                                        
                                        VStack {
                                            ForEach((activeList?.items ?? [Item]())
                                                .filter({
                                                    if (searchText.isEmpty || $0.name.localizedCaseInsensitiveContains(searchText)),
                                                    let category = $0.category {
                                                        return category == group
                                                    }
                                                    else {
                                                        return false
                                                    }
                                                })) { item in
                                                    ActiveItemComponent(item: item, itemToEdit: $itemToEdit, showCategory: false, listColor: Color(red: activeList?.colorRed ?? 0, green: activeList?.colorGreen ?? 0, blue: activeList?.colorBlue ?? 0))
                                                }
                                                .background(.quinary)
                                                .clipShape(RoundedRectangle(cornerRadius: 10))
                                            
                                        }
                                        .padding(.top, 10)
                                        
                                    }
                                    
                                    if (activeList?.withNameHasNilCategory(term: searchText) ?? false) {
                                        
                                        Text("(No category)")
                                            .font(.system(size: 20, weight: .bold))
                                            .foregroundStyle((Theme(rawValue: theme) ?? .blue).get1())
                                            .padding(.horizontal, 30)
                                            .padding(.vertical, 15)
                                            .background(Color(red: activeList?.colorRed ?? 0, green: activeList?.colorGreen ?? 0, blue: activeList?.colorBlue ?? 0))
                                            .clipShape(UnevenRoundedRectangle(cornerRadii:
                                                    .init(topLeading: 10, bottomLeading: 0, bottomTrailing: 0, topTrailing: 10)))
                                            .padding(.top, 20)
                                        
                                        VStack {
                                            ForEach((activeList?.items ?? [Item]())
                                                .filter({
                                                    (searchText.isEmpty || $0.name.localizedCaseInsensitiveContains(searchText)) && $0.category == nil
                                                })) { item in
                                                    ActiveItemComponent(item: item, itemToEdit: $itemToEdit, showCategory: false, listColor: Color(red: activeList?.colorRed ?? 0, green: activeList?.colorGreen ?? 0, blue: activeList?.colorBlue ?? 0))
                                                }
                                                .background(.quinary)
                                                .clipShape(RoundedRectangle(cornerRadius: 10))
                                        }
                                        .padding(.top, 10)
                                    }
                                    
                                }
                                
                                // bag grouping
                                else {
                                    ForEach(bags.filter({
                                        activeList?.withNameHasBag(bag: $0, term: searchText) ?? false
                                    })) { group in
                                        
                                        Text(group.name)
                                            .font(.system(size: 20, weight: .bold))
                                            .foregroundStyle((Theme(rawValue: theme) ?? .blue).get1())
                                            .padding(.horizontal, 30)
                                            .padding(.vertical, 15)
                                            .background(Color(red: activeList?.colorRed ?? 0, green: activeList?.colorGreen ?? 0, blue: activeList?.colorBlue ?? 0))
                                            .clipShape(UnevenRoundedRectangle(cornerRadii:
                                                    .init(topLeading: 10, bottomLeading: 0, bottomTrailing: 0, topTrailing: 10)))
                                            .padding(.top, 20)
                                        
                                        VStack {
                                            ForEach((activeList?.items ?? [Item]())
                                                .filter({
                                                    if (searchText.isEmpty || $0.name.localizedCaseInsensitiveContains(searchText)),
                                                    let bag = $0.bag {
                                                        return bag == group
                                                    }
                                                    else {
                                                        return false
                                                    }
                                                })) { item in
                                                    ActiveItemComponent(item: item, itemToEdit: $itemToEdit, showCategory: true, listColor: Color(red: activeList?.colorRed ?? 0, green: activeList?.colorGreen ?? 0, blue: activeList?.colorBlue ?? 0))
                                                }
                                                .background(.quinary)
                                                .clipShape(RoundedRectangle(cornerRadius: 10))
                                            
                                        }
                                        .padding(.top, 10)
                                        
                                    }
                                    
                                    if (activeList?.withNameHasNilBag(term: searchText) ?? false) {
                                        
                                        Text("(No bag)")
                                            .font(.system(size: 20, weight: .bold))
                                            .foregroundStyle((Theme(rawValue: theme) ?? .blue).get1())
                                            .padding(.horizontal, 30)
                                            .padding(.vertical, 15)
                                            .background(Color(red: activeList?.colorRed ?? 0, green: activeList?.colorGreen ?? 0, blue: activeList?.colorBlue ?? 0))
                                            .clipShape(UnevenRoundedRectangle(cornerRadii:
                                                    .init(topLeading: 10, bottomLeading: 0, bottomTrailing: 0, topTrailing: 10)))
                                            .padding(.top, 20)
                                        
                                        VStack {
                                            ForEach((activeList?.items ?? [Item]())
                                                .filter({
                                                    (searchText.isEmpty || $0.name.localizedCaseInsensitiveContains(searchText)) && $0.bag == nil
                                                })) { item in
                                                    ActiveItemComponent(item: item, itemToEdit: $itemToEdit, showCategory: true, listColor: Color(red: activeList?.colorRed ?? 0, green: activeList?.colorGreen ?? 0, blue: activeList?.colorBlue ?? 0))
                                                }
                                                .background(.quinary)
                                                .clipShape(RoundedRectangle(cornerRadius: 10))
                                        }
                                        .padding(.top, 10)
                                    }
                                }
                            }
                            .padding(.horizontal, 15)
                            .padding(.bottom, 15)
                        }
                        .sheet(item: $itemToEdit, onDismiss: {
                            itemEditShowingNames = false
                        }) { data in
                            if let activeList {
                                EditItemView(list: activeList, item: data, showingNames: $itemEditShowingNames)
                                    .presentationDetents([.fraction(itemEditShowingNames ? 0.6 : 0.45)])
                            }
                        }
                        .scrollDismissesKeyboard(.immediately)
                    }
                    
                }
            }
            
            .background((Theme(rawValue: theme) ?? .blue).get1())
            
            .buttonStyle(.plain)
            .tint((Theme(rawValue: theme) ?? .blue).get2())
            .onAppear {
                activeList = activeLists.first(where: {
                    $0.activeSelected
                })
            }
    }
}
