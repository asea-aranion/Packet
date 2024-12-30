//
//  ActiveListView.swift
//  Packet
//
//  Created by Leia Spagnola on 12/29/24.
//

import SwiftUI
import SwiftData

struct ActiveListView: View {
    
    @Query(filter: #Predicate<PackingList> { list in list.active } ) var activeLists: [PackingList]
    @Query var bags: [Bag]
    @Query var categories: [Category]
    
    @State var activeList: PackingList?
    @State var groupByCategory: Bool = true
    @State var itemToEdit: Item?
    
    @AppStorage("theme") var theme: Int = 0
    
    var body: some View {
        
        VStack {
            if (activeLists.isEmpty) {
                Text("No active lists")
                
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
            else {
                // active list selector
                HStack {
                    Spacer()
                    Menu {
                        ForEach(activeLists) { list in
                            Button(list.name) {
                                activeList = list
                            }
                        }
                    } label: {
                        Image(systemName: "chevron.down")
                            .font(.system(size: 24, weight: .bold))
                            .foregroundStyle((Theme(rawValue: theme) ?? .blue).get2())
                    }
                }
                .padding(.horizontal, 15)
                
                if (activeList == nil) {
                    Text("No list selected")
                    
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
                                    Text("incomplete")
                                }
                                
                            }
                            .foregroundStyle(.white)
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
                                .padding(10)
                            
                            // items
                            
                            // category grouping
                            if (groupByCategory) {
                                ForEach(categories) { group in
                                    
                                    Text(group.name)
                                        .font(.system(size: 20, weight: .bold))
                                        .foregroundStyle(.white)
                                        .padding(.horizontal, 30)
                                        .padding(.vertical, 15)
                                        .background(Color(red: activeList?.colorRed ?? 0, green: activeList?.colorGreen ?? 0, blue: activeList?.colorBlue ?? 0))
                                        .clipShape(UnevenRoundedRectangle(cornerRadii:
                                                .init(topLeading: 10, bottomLeading: 0, bottomTrailing: 0, topTrailing: 10)))
                                        .padding(.top, 20)
                                    
                                    VStack {
                                        ForEach((activeList?.items ?? [Item]())
                                            .filter({
                                                if let category = $0.category {
                                                    return category == group
                                                }
                                                else {
                                                    return false
                                                }
                                            })) { item in
                                                
                                                HStack {
                                                    Button {
                                                        withAnimation(.bouncy(duration: 0.2)) {
                                                            item.checked.toggle()
                                                        }
                                                    } label: {
                                                        Image(systemName: item.checked ? "checkmark.circle" : "circle")
                                                            .foregroundStyle(Color(red: activeList?.colorRed ?? 0, green: activeList?.colorGreen ?? 0, blue: activeList?.colorBlue ?? 0))
                                                            .font(.system(size: 24))
                                                            .padding(5)
                                                        
                                                    }
                                                    Button {
                                                        itemToEdit = item
                                                    } label: {
                                                        Text(String(item.quantity))
                                                            .padding(10)
                                                            .background(.quinary)
                                                            .clipShape(Circle())
                                                        Text(item.name)
                                                            .padding(.leading, 3)
                                                        Image(systemName: "circle.fill")
                                                            .font(.system(size: 8))
                                                        Text(item.bag?.name ?? "(No bag)")
                                                        Spacer()
                                                    }
                                                    
                                                }
                                                .padding(.horizontal, 10)
                                                .padding(.vertical, 5)
                                                
                                                
                                            }
                                            .background(Color("Background"))
                                            .clipShape(RoundedRectangle(cornerRadius: 10))
                                        
                                    }
                                    .padding(.top, 10)
                                    
                                }
                                
                                Text("(No category)")
                                    .font(.system(size: 20, weight: .bold))
                                    .foregroundStyle(.white)
                                    .padding(.horizontal, 30)
                                    .padding(.vertical, 15)
                                    .background(Color(red: activeList?.colorRed ?? 0, green: activeList?.colorGreen ?? 0, blue: activeList?.colorBlue ?? 0))
                                    .clipShape(UnevenRoundedRectangle(cornerRadii:
                                            .init(topLeading: 10, bottomLeading: 0, bottomTrailing: 0, topTrailing: 10)))
                                    .padding(.top, 20)
                                
                                VStack {
                                    ForEach((activeList?.items ?? [Item]())
                                        .filter({
                                            $0.category == nil
                                        })) { item in
                                            HStack {
                                                Button {
                                                    withAnimation(.bouncy(duration: 0.2)) {
                                                        item.checked.toggle()
                                                    }
                                                } label: {
                                                    Image(systemName: item.checked ? "checkmark.circle" : "circle")
                                                        .foregroundStyle(Color(red: activeList?.colorRed ?? 0, green: activeList?.colorGreen ?? 0, blue: activeList?.colorBlue ?? 0))
                                                        .font(.system(size: 24))
                                                        .padding(5)
                                                    
                                                }
                                                Button {
                                                    itemToEdit = item
                                                } label: {
                                                    Text(String(item.quantity))
                                                        .padding(10)
                                                        .background(.quinary)
                                                        .clipShape(Circle())
                                                    Text(item.name)
                                                        .padding(.leading, 3)
                                                    Image(systemName: "circle.fill")
                                                        .font(.system(size: 8))
                                                    Text(item.bag?.name ?? "(No bag)")
                                                    Spacer()
                                                }
                                                
                                            }
                                            .padding(.horizontal, 10)
                                            .padding(.vertical, 5)
                                        }
                                        .background(Color("Background"))
                                        .clipShape(RoundedRectangle(cornerRadius: 10))
                                }
                                .padding(.top, 10)
                            }
                            
                            // bag grouping
                            else {
                                ForEach(bags) { group in
                                    
                                    Text(group.name)
                                        .font(.system(size: 20, weight: .bold))
                                        .foregroundStyle(.white)
                                        .padding(.horizontal, 30)
                                        .padding(.vertical, 15)
                                        .background(Color(red: activeList?.colorRed ?? 0, green: activeList?.colorGreen ?? 0, blue: activeList?.colorBlue ?? 0))
                                        .clipShape(UnevenRoundedRectangle(cornerRadii:
                                                .init(topLeading: 10, bottomLeading: 0, bottomTrailing: 0, topTrailing: 10)))
                                        .padding(.top, 20)
                                    
                                    VStack {
                                        ForEach((activeList?.items ?? [Item]())
                                            .filter({
                                                if let bag = $0.bag {
                                                    return bag == group
                                                }
                                                else {
                                                    return false
                                                }
                                            })) { item in
                                                
                                                HStack {
                                                    Button {
                                                        withAnimation(.bouncy(duration: 0.2)) {
                                                            item.checked.toggle()
                                                        }
                                                    } label: {
                                                        Image(systemName: item.checked ? "checkmark.circle" : "circle")
                                                            .foregroundStyle(Color(red: activeList?.colorRed ?? 0, green: activeList?.colorGreen ?? 0, blue: activeList?.colorBlue ?? 0))
                                                            .font(.system(size: 24))
                                                            .padding(5)
                                                        
                                                    }
                                                    Button {
                                                        itemToEdit = item
                                                    } label: {
                                                        Text(String(item.quantity))
                                                            .padding(10)
                                                            .background(.quinary)
                                                            .clipShape(Circle())
                                                        Text(item.name)
                                                            .padding(.leading, 3)
                                                        Image(systemName: "circle.fill")
                                                            .font(.system(size: 8))
                                                        Text(item.category?.name ?? "(No category)")
                                                        Spacer()
                                                    }
                                                    
                                                }
                                                .padding(.horizontal, 10)
                                                .padding(.vertical, 5)
                                                
                                                
                                            }
                                            .background(Color("Background"))
                                            .clipShape(RoundedRectangle(cornerRadius: 10))
                                        
                                    }
                                    .padding(.top, 10)
                                    
                                }
                                
                                Text("(No bag)")
                                    .font(.system(size: 20, weight: .bold))
                                    .foregroundStyle(.white)
                                    .padding(.horizontal, 30)
                                    .padding(.vertical, 15)
                                    .background(Color(red: activeList?.colorRed ?? 0, green: activeList?.colorGreen ?? 0, blue: activeList?.colorBlue ?? 0))
                                    .clipShape(UnevenRoundedRectangle(cornerRadii:
                                            .init(topLeading: 10, bottomLeading: 0, bottomTrailing: 0, topTrailing: 10)))
                                    .padding(.top, 20)
                                
                                VStack {
                                    ForEach((activeList?.items ?? [Item]())
                                        .filter({
                                            $0.bag == nil
                                        })) { item in
                                            HStack {
                                                Button {
                                                    withAnimation(.bouncy(duration: 0.2)) {
                                                        item.checked.toggle()
                                                    }
                                                } label: {
                                                    Image(systemName: item.checked ? "checkmark.circle" : "circle")
                                                        .foregroundStyle(Color(red: activeList?.colorRed ?? 0, green: activeList?.colorGreen ?? 0, blue: activeList?.colorBlue ?? 0))
                                                        .font(.system(size: 24))
                                                        .padding(5)
                                                    
                                                }
                                                Button {
                                                    itemToEdit = item
                                                } label: {
                                                    Text(String(item.quantity))
                                                        .padding(10)
                                                        .background(.quinary)
                                                        .clipShape(Circle())
                                                    Text(item.name)
                                                        .padding(.leading, 3)
                                                    Image(systemName: "circle.fill")
                                                        .font(.system(size: 8))
                                                    Text(item.category?.name ?? "(No category)")
                                                    Spacer()
                                                }
                                                
                                            }
                                            .padding(.horizontal, 10)
                                            .padding(.vertical, 5)
                                        }
                                        .background(Color("Background"))
                                        .clipShape(RoundedRectangle(cornerRadius: 10))
                                }
                                .padding(.top, 10)
                            
                            }
                            
                            
                            
                        }
                        .padding(.horizontal, 15)
                    }
                    
                }
                
            }
        }
        .background((Theme(rawValue: theme) ?? .blue).get1())
        .popover(item: $itemToEdit) { data in
            EditItemView(item: data)
        }
        .buttonStyle(.plain)
    }
}
