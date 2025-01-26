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
    @State var itemToEdit: Item? // displays editing sheet on change
    @State var searchText: String = ""
    @State var itemEditShowingNames: Bool = false // allows height of editing sheet to change based on
                                                  // whether name autofill options are displayed
    @AppStorage("theme") var theme: Int = 0
    
    @FocusState var searchFocused: Bool // allows x button to escape search field
    
    var body: some View {
        
            VStack {
                
                // if there are no active lists, show message
                if (activeLists.isEmpty) {
                    // MARK: No active lists x-mark and message
                    VStack {
                        Image(systemName: "xmark.circle")
                            .font(.system(size: 48, weight: .bold))
                            .foregroundStyle((Theme(rawValue: theme) ?? .blue).get2())
                            .padding(.bottom, 20)
                        Text("No active lists")
                            .font(.title3).bold()
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    
                }
                // otherwise, show active list selector
                else {
                    // MARK: Active lists menu
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
                                .font(.system(size: 28, weight: .bold))
                                .foregroundStyle((Theme(rawValue: theme) ?? .blue).get2())
                        }
                    }
                    .padding(.horizontal, 15)
                    
                    // if no active list is selected, show message below selector
                    if (activeList == nil) {
                        // MARK: No active list selected arrow and message
                        VStack {
                            Image(systemName: "chevron.up.forward.2")
                                .font(.system(size: 48, weight: .bold))
                                .foregroundStyle((Theme(rawValue: theme) ?? .blue).get2())
                                .padding(.bottom, 20)
                            Text("No list selected")
                                .font(.title3).bold()
                        }
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        
                    }
                    // otherwise, show active list UI to check off items
                    else {
                        
                        // MARK: Active list item display
                        ScrollView {
                            VStack(alignment: .leading, spacing: 0) {
                                
                                // MARK: List title header
                                HStack {
                                    Text(activeList?.name ?? "")
                                        .font(.title2).bold()
                                    Spacer()
                                    VStack {
                                        Text(String((activeList?.items ?? [])
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
                                
                                // MARK: Picker to group by item categories or bags
                                GroupPickerComponent(groupByCategory: $groupByCategory)
                                .padding(.vertical, 10)
                                
                                // MARK: Item search bar
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
                                
                                if (groupByCategory) {
                                    
                                    // MARK: Item display for category grouping
                                    ForEach(categories.filter({
                                        // only shows sections for categories included in this list
                                        activeList?.withNameHasCategory(category: $0, term: searchText) ?? false
                                    } )) { group in
                                        
                                        // category tab-shaped header
                                        Text(group.name)
                                            .font(.title3).bold()
                                            .foregroundStyle((Theme(rawValue: theme) ?? .blue).get1())
                                            .padding(.horizontal, 30)
                                            .padding(.vertical, 15)
                                            .background(Color(red: activeList?.colorRed ?? 0, green: activeList?.colorGreen ?? 0, blue: activeList?.colorBlue ?? 0))
                                            .clipShape(UnevenRoundedRectangle(cornerRadii:
                                                    .init(topLeading: 10, bottomLeading: 0, bottomTrailing: 0, topTrailing: 10)))
                                            .padding(.top, 20)
                                        
                                        VStack {
                                            ForEach((activeList?.items ?? [])
                                                .filter({
                                                    // shows all items if nothing has been entered in search field
                                                    if (searchText.isEmpty ||
                                                        $0.name.localizedCaseInsensitiveContains(searchText)),
                                                    let category = $0.category {
                                                        return category == group
                                                    }
                                                    // if category is nil, item is not shown here
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
                                    
                                    // shows section for nil/no category if included in this list
                                    if (activeList?.withNameHasNilCategory(term: searchText) ?? false) {
                                        
                                        Text("(No category)")
                                            .font(.title3).bold()
                                            .foregroundStyle((Theme(rawValue: theme) ?? .blue).get1())
                                            .padding(.horizontal, 30)
                                            .padding(.vertical, 15)
                                            .background(Color(red: activeList?.colorRed ?? 0, green: activeList?.colorGreen ?? 0, blue: activeList?.colorBlue ?? 0))
                                            .clipShape(UnevenRoundedRectangle(cornerRadii:
                                                    .init(topLeading: 10, bottomLeading: 0, bottomTrailing: 0, topTrailing: 10)))
                                            .padding(.top, 20)
                                        
                                        VStack {
                                            ForEach((activeList?.items ?? [])
                                                .filter({
                                                    // shows all items if nothing has been entered in search field
                                                    (searchText.isEmpty || $0.name.localizedCaseInsensitiveContains(searchText)) &&
                                                        $0.category == nil
                                                })) { item in
                                                    ActiveItemComponent(item: item, itemToEdit: $itemToEdit, showCategory: false, listColor: Color(red: activeList?.colorRed ?? 0, green: activeList?.colorGreen ?? 0, blue: activeList?.colorBlue ?? 0))
                                                }
                                                .background(.quinary)
                                                .clipShape(RoundedRectangle(cornerRadius: 10))
                                        }
                                        .padding(.top, 10)
                                    }
                                    
                                }
                                
                                // MARK: Item display for bag grouping
                                else {
                                    ForEach(bags.filter({
                                        // only shows sections for bags included in this list
                                        activeList?.withNameHasBag(bag: $0, term: searchText) ?? false
                                    })) { group in
                                        
                                        // bag tab-shaped header
                                        Text(group.name)
                                            .font(.title3).bold()
                                            .foregroundStyle((Theme(rawValue: theme) ?? .blue).get1())
                                            .padding(.horizontal, 30)
                                            .padding(.vertical, 15)
                                            .background(Color(red: activeList?.colorRed ?? 0, green: activeList?.colorGreen ?? 0, blue: activeList?.colorBlue ?? 0))
                                            .clipShape(UnevenRoundedRectangle(cornerRadii:
                                                    .init(topLeading: 10, bottomLeading: 0, bottomTrailing: 0, topTrailing: 10)))
                                            .padding(.top, 20)
                                        
                                        VStack {
                                            ForEach((activeList?.items ?? [])
                                                .filter({
                                                    // shows all items if nothing has been entered in search field
                                                    if (searchText.isEmpty || $0.name.localizedCaseInsensitiveContains(searchText)),
                                                    let bag = $0.bag {
                                                        return bag == group
                                                    }
                                                    // if bag is nil, item is not shown here
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
                                    
                                    // shows section for nil/no category if included in this list
                                    if (activeList?.withNameHasNilBag(term: searchText) ?? false) {
                                        
                                        Text("(No bag)")
                                            .font(.title3).bold()
                                            .foregroundStyle((Theme(rawValue: theme) ?? .blue).get1())
                                            .padding(.horizontal, 30)
                                            .padding(.vertical, 15)
                                            .background(Color(red: activeList?.colorRed ?? 0, green: activeList?.colorGreen ?? 0, blue: activeList?.colorBlue ?? 0))
                                            .clipShape(UnevenRoundedRectangle(cornerRadii:
                                                    .init(topLeading: 10, bottomLeading: 0, bottomTrailing: 0, topTrailing: 10)))
                                            .padding(.top, 20)
                                        
                                        VStack {
                                            ForEach((activeList?.items ?? [])
                                                .filter({
                                                    // shows all items if nothing has been entered in search field
                                                    (searchText.isEmpty || $0.name.localizedCaseInsensitiveContains(searchText)) &&
                                                        $0.bag == nil
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
                        // sheet displays to edit tapped item
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
            // attempts to get selected list from last launch if one exists
            .onAppear {
                activeList = activeLists.first(where: {
                    $0.activeSelected
                })
            }
    }
}
