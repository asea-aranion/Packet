//
//  Bag.swift
//  Packet
//
//  Created by Leia Spagnola on 12/24/24.
//

import SwiftData

@Model
class Bag {
    var name: String
    
    init(name: String) {
        self.name = name
    }
    
    func equals(_ other: Bag?) -> Bool {
        var result = false
        
        if let otherBag = other {
            result = otherBag.name == name
        }
        
        return result
    }
}
