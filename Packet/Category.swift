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
    
    init(name: String) {
        self.name = name
    }
    
    func equals(_ other: Category?) -> Bool {
        var result = false
        
        if let otherCat = other {
            result = name == otherCat.name
        }
        
        return result
    }
}
