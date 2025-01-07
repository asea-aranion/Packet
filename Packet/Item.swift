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
    
    init(from source: Item) {
        self.name = source.name
        self.usages = source.usages
        self.quantity = source.quantity
        self.bag = source.bag
        self.category = source.category
        
    }
}
