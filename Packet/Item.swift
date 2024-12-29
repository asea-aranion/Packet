//
//  Item.swift
//  Packet
//
//  Created by Leia Spagnola on 12/23/24.
//

import SwiftData

@Model
class Item {
    
    var name: String = "New Item"
    var usages: Int = 0
    var quantity: Int = 1
    var checked: Bool = false
    @Relationship var bag: Bag?
    @Relationship var category: Category?
    
    init() {
        
    }
    
    static func copy(from source: Item) -> Item {
        let newItem = Item()
        
        newItem.name = source.name
        newItem.usages = source.usages
        newItem.quantity = source.quantity
        newItem.bag = source.bag
        newItem.category = source.category
        
        return newItem
    }
}
