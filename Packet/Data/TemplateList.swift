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
    var colorRed: Double = 71 / 255
    var colorGreen: Double = 159 / 255
    var colorBlue: Double = 211 / 255
    @Relationship(deleteRule: .cascade) var items: [Item]?
    
    init() {
        items = [Item]()
    }
    
    init(from source: TemplateList) {
        self.name = source.name + " copy"
        self.colorRed = source.colorRed
        self.colorGreen = source.colorGreen
        self.colorBlue = source.colorBlue
        
        self.items = [Item]()
        
        source.items?.forEach {
            self.items?.append(Item.init(from: $0))
        }
    }
}
