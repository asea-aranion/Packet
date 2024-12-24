//
//  Bags.swift
//  Packet
//
//  Created by Leia Spagnola on 12/23/24.
//

import SwiftData

@Model
class UserInfo {
    
    @Relationship var allItems: [Item]?
    var bags: [String] = [String]()
    var categories: [String] = [String]()
    
    init(allItems: [Item]? = nil,
         bags: [String] = ["Carry-on", "Checked bag", "Personal item"],
         categories: [String] = ["Clothing", "Toiletries", "Electronics", "Other"]
    ) {
        self.allItems = allItems
        self.bags = bags
        self.categories = categories
    }
}
