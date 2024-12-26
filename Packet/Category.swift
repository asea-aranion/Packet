//
//  Category.swift
//  Packet
//
//  Created by Leia Spagnola on 12/24/24.
//

import SwiftData

@Model
class Category {
    
    var name: String
    var inEditMode: Bool = false
    
    init(name: String) {
        self.name = name
    }
    
}
