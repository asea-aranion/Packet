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
    @Relationship(deleteRule: .cascade, inverse: \Item.templateList) var items: [Item]?
    
    func subtractItemNames(_ names: inout Set<String>) {
        
        guard let items else {
            return
        }
        
        items.forEach {
            names.remove($0.name)
        }
    }
    
    func uniqueItemNames() -> Set<String> {
        
        var result: Set<String> = []
        
        guard let items else { return result }
        
        items.forEach { result.insert($0.name) }
        
        return result
    }
    
    init() {
        items = [Item]()
    }
    
    init(name: String, colorRed: Double, colorGreen: Double, colorBlue: Double, items: [Item]) {
        self.name = name
        self.colorRed = colorRed
        self.colorGreen = colorGreen
        self.colorBlue = colorBlue
        self.items = items
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
    
    init(from source: PackingList) {
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
