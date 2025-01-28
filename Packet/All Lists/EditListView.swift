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
    @State var ignoreCategory: Bool = true // sets picker to Any category
    @State var ignoreBag: Bool = true // sets picker to Any bag
    @State var showDeleteConf: Bool = false
    @State var weatherUpdated: Bool = false // shows Load Weather button when false, weather display when true
    @State var itemEditShowingNames: Bool = false // allows height of editing sheet to change based on
                                                  // whether name autofill options are displayed
    
    @AppStorage("theme") var theme: Int = 0
    
    @Binding var path: NavigationPath // allows resetting of path when list is deleted or duplicated
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                
                // MARK: List name textfield
                TextField("Packing list name", text: $list.name)
                    .multilineTextAlignment(.center)
                    .textFieldStyle(.plain)
                    .font(.title).bold()
                    .padding(5)
                    .background((Theme(rawValue: theme) ?? .blue).get1())
                    .clipShape(RoundedRectangle(cornerRadius: 6))
                    .foregroundStyle(Color(red: list.colorRed, green: list.colorGreen, blue: list.colorBlue))
                    .padding(15)
                    .background(Color(red: list.colorRed, green: list.colorGreen, blue: list.colorBlue))
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .padding(15)
                
                // MARK: Buttons to toggle active and archived
                HStack(spacing: 15) {
                    
                    // can only activate list if it is not archived
                    if (!list.archived) {
                        Button {
                            withAnimation {
                                list.active.toggle()
                            }
                        } label: {
                            if (list.active) {
                                Text("\(Image(systemName: "checkmark")) Active")
                                    .bold()
                                    .padding(.vertical, 15)
                                    .frame(maxWidth: .infinity)
                                    .background(Color(red: list.colorRed, green: list.colorGreen, blue: list.colorBlue))
                                    .clipShape(Capsule())
                                    .foregroundStyle(.white)
                            }
                            else {
                                Text("\(Image(systemName: "xmark")) Inactive")
                                    .bold()
                                    .padding(.vertical, 15)
                                    .frame(maxWidth: .infinity)
                                    .background(.quinary)
                                    .clipShape(Capsule())
                                    .foregroundStyle(Color(red: list.colorRed, green: list.colorGreen, blue: list.colorBlue))
                            }
                        }
                        .animation(.easeInOut, value: list.active)
                        .transition(.move(edge: .leading))
                    }
                    
                    Button {
                        withAnimation(.easeInOut(duration: 0.1)) {
                            if (!list.archived) {
                                list.activeSelected = false
                                list.active = false
                                list.archived = true
                            } else {
                                list.archived = false
                            }
                        }
                    } label: {
                        if (!list.archived) {
                            Text("\(Image(systemName: "square.stack.3d.up")) Unarchived")
                                .bold()
                                .padding(.vertical, 15)
                                .frame(maxWidth: .infinity)
                                .background(Color(red: list.colorRed, green: list.colorGreen, blue: list.colorBlue))
                                .clipShape(Capsule())
                                .foregroundStyle(.white)
                        }
                        else {
                            Text("\(Image(systemName: "archivebox.fill")) Archived")
                                .bold()
                                .padding(.vertical, 15)
                                .padding(.horizontal, 20)
                                .background(.quinary)
                                .clipShape(Capsule())
                                .foregroundStyle(Color(red: list.colorRed, green: list.colorGreen, blue: list.colorBlue))
                                .frame(maxWidth: .infinity)
                        }
                    }
                }
                .padding(.horizontal, 15)
                .padding(.bottom, 10)
                
                // MARK: List color editor
                ColorPicker("\(Image(systemName: "paintbrush")) Color", selection: $selectedColor)
                    // resolves selected color to store its RGB values as doubles,
                    // since SwiftData models cannot store Colors by default
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
                
                // MARK: Departure and return date editors
                VStack {
                    DatePicker("\(Image(systemName: "calendar")) Departure date", selection: $list.startDate, displayedComponents: .date)
                        .padding(15)
                        
                        // if user sets departure to be later than return, return is automatically
                        // set to the same date as departure
                        .onChange(of: list.startDate) {
                            if (list.startDate > list.endDate) {
                                list.endDate = list.startDate
                            }
                        }
                    
                    // edit end date
                    DatePicker("\(Image(systemName: "calendar")) Return date", selection: $list.endDate,
                               in: list.startDate...Date.distantFuture, displayedComponents: .date)
                    .padding(15)
                }
                .background(.quinary)
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .padding(.bottom, 10)
                .padding(.horizontal, 15)
                
                // MARK: Destination editor and display
                LocationComponent(list: list)
                    .padding(.horizontal, 15)
                
                // MARK: Destination weather display
                WeatherComponent(weatherUpdated: $weatherUpdated, list: list)
                    .padding(.horizontal, 15)
                
                // MARK: Buttons for making template from or deleting list
                HStack(spacing: 15) {
                    
                    Button {
                        modelContext.insert(TemplateList(from: list))
                        
                    } label: {
                        Text("\(Image(systemName: "bookmark")) Make Template")
                            .font(.body.bold())
                            .padding(.vertical, 15)
                        
                            .frame(maxWidth: .infinity)
                            .foregroundStyle(Color(red: list.colorRed, green: list.colorGreen, blue: list.colorBlue))
                            .background(.quinary)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                    }
                    .buttonStyle(.plain)
                    
                    Button {
                        showDeleteConf = true
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
                
                // MARK: List item label and display
                Text("Items")
                    .foregroundStyle((Theme(rawValue: theme) ?? .blue).get1())
                    .font(.title3).bold()
                    .padding(.horizontal, 30)
                    .padding(.vertical, 15)
                    .background(Color(red: list.colorRed, green: list.colorGreen, blue: list.colorBlue))
                    .clipShape(UnevenRoundedRectangle(cornerRadii:
                            .init(topLeading: 10, bottomLeading: 0, bottomTrailing: 0, topTrailing: 10)))
                    .padding(.leading, 15)
                    .padding(.top, 20)
                
                // add item button
                Button {
                    let newItem = Item()
                    list.items?.append(newItem)
                    itemToEdit = newItem
                } label: {
                    AddLabelComponent(color: Color(red: list.colorRed, green: list.colorGreen, blue: list.colorBlue), text: "Add Item")
                }
                .buttonStyle(.plain)
                
                // MARK: Menu pickers for filtering items
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
                        Text("\(Image(systemName: "tag.fill")) \(ignoreCategory ? "Any" : (categoryFilter?.name ?? "(No category)")) \(Image(systemName: "chevron.down"))")
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
                        Text("\(Image(systemName: "bag.fill")) \(ignoreBag ? "Any" : (bagFilter?.name ?? "(No bag)")) \(Image(systemName: "chevron.down"))")
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
                LazyVStack(alignment: .leading) {
                    ForEach((list.items ?? [])
                        .filter({
                            // if Any is selected, does not check that items have a certain category/bag
                            (ignoreCategory || $0.category == categoryFilter)
                            // items must fulfill both category and bag picker selections
                            && (ignoreBag || $0.bag == bagFilter)
                        })) { item in
                            Button {
                                itemToEdit = item
                            } label: {
                                ItemComponent(item: item, listColor: selectedColor)
                            }
                            .buttonStyle(.plain)
                            .padding(.vertical, 5)
                            .padding(.horizontal, 15)
                        }
                }
                
            }
            .padding(.bottom, 15)
        }
        // initializes color picker selection
        .onAppear {
            selectedColor = Color(red: list.colorRed, green: list.colorGreen, blue: list.colorBlue)
        }
        // sheet displays to edit tapped item
        .sheet(item: $itemToEdit, onDismiss: {
            itemEditShowingNames = false
        }) { data in
            EditItemView(list: list, item: data, showingNames: $itemEditShowingNames,
                         duration: Calendar.current.dateComponents([.day], from: Calendar.current.startOfDay(for: list.startDate), to: Calendar.current.startOfDay(for: list.endDate)).day ?? 0)
            .presentationDetents([itemEditShowingNames ? .height(500) : .height(400)])
        }
        // delete confirmation
        .confirmationDialog("Delete this packing list?", isPresented: $showDeleteConf, actions: {
            Button("Delete", role: .destructive) {
                modelContext.delete(list)
                path = NavigationPath()
            }
        }, message: {
            Text("This will delete all this list's data and items.")
        })
        
        .background((Theme(rawValue: theme) ?? .blue).get1())
        .tint(Color(red: list.colorRed, green: list.colorGreen, blue: list.colorBlue))
        .scrollDismissesKeyboard(.immediately)
    }
}
