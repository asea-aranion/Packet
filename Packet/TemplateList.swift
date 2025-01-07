//
//  TemplateList.swift
//  Packet
//
//  Created by Leia Spagnola on 1/6/25.
//

import SwiftData

@Model
class TemplateList {
    
    var name: String = "New Template"
    @Relationship(deleteRule: .cascade) var items: [Item]?
    
    init() {
        items = [Item]()
    }
}
