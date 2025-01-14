//
//  List.swift
//  Packet
//
//  Created by Leia Spagnola on 12/23/24.
//

import SwiftData
import SwiftUI
import CoreLocation

@Model
class PackingList {
    
    var name: String = "New Packing List"
    var colorRed: Double = 71 / 255
    var colorGreen: Double = 159 / 255
    var colorBlue: Double = 211 / 255
    @Relationship(deleteRule: .cascade) var items: [Item]?
    var active: Bool = false
    var activeSelected: Bool = false
    var startDate: Date = Date()
    var endDate: Date = Date()
    var long: Double = 0
    var lat: Double = 0
    
    init() {
        items = [Item]()
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
    
    init(from source: TemplateList) {
        self.name = source.name
        
        self.items = [Item]()
        
        source.items?.forEach {
            self.items?.append(Item.init(from: $0))
        }
    }
    
    func uniqueItemNames() -> Set<String> {
        
        var result: Set<String> = []
        
        guard let items else { return result }
        
        items.forEach { result.insert($0.name) }
        
        return result
    }
    
    func withNameHasCategory(category: Category, term: String) -> Bool {
        
        guard let items else { return false }
        
        return items.contains(where: {
            (term.isEmpty || $0.name.localizedCaseInsensitiveContains(term)) && $0.category == category
        })
    }
    
    func withNameHasNilCategory(term: String) -> Bool {
        
        guard let items else { return false }
        
        return items.contains(where: {
            (term.isEmpty || $0.name.localizedCaseInsensitiveContains(term)) && $0.category == nil
        })
    }
    
    func withNameHasBag(bag: Bag, term: String) -> Bool {
        
        guard let items else { return false }
        
        return items.contains(where: {
            (term.isEmpty || $0.name.localizedCaseInsensitiveContains(term)) && $0.bag == bag
        })
    }
    
    func withNameHasNilBag(term: String) -> Bool {
        
        guard let items else { return false }
        
        return items.contains(where: {
            (term.isEmpty || $0.name.localizedCaseInsensitiveContains(term)) && $0.bag == nil
        })
    }
    
}
