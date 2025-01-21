//
//  Item.swift
//  Packet
//
//  Created by Leia Spagnola on 12/23/24.
//

import SwiftData

@Model
class Item {
    
    var name: String = ""
    var quantity: Int = 1
    var checked: Bool = false
    @Relationship var bag: Bag?
    @Relationship var category: Category?
    
    init() {
        
    }
    
    init(name: String, quantity: Int, bag: Bag, category: Category) {
        self.name = name
        self.quantity = quantity
        self.bag = bag
        self.category = category
    }
    
    init(from source: Item) {
        self.name = source.name
        self.quantity = source.quantity
        self.bag = source.bag
        self.category = source.category
        
    }
}
