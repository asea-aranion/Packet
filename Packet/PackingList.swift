//
//  List.swift
//  Packet
//
//  Created by Leia Spagnola on 12/23/24.
//

import SwiftData
import SwiftUI

@Model
class PackingList {
    
    var name: String = "New Packing List"
    var colorRed: Double = 0.8
    var colorGreen: Double = 0.9
    var colorBlue: Double = 0.8
    @Relationship(deleteRule: .cascade) var items: [Item]?
    var tripLength: Int = 1
    var active: Bool = false
    var startDate: Date = Date()
    var endDate: Date = Date()
    
    init() {
        items = [Item]()
    }
    
    func uniqueItemNames() -> Set<String> {
        
        var result: Set<String> = []
        
        guard let items else { return result }
        
        items.forEach { result.insert($0.name) }
        
        return result
    }
    
    func hasCategory(category: Category) -> Bool {
        
        guard let items else { return false }
        
        return items.contains(where: { $0.category == category })
    }
    
    func hasNilCategory() -> Bool {
        
        guard let items else { return false }
        
        return items.contains(where: { $0.category == nil })
    }
    
    func hasBag(bag: Bag) -> Bool {
        
        guard let items else { return false }
        
        return items.contains(where: { $0.bag == bag })
    }
    
    func hasNilBag() -> Bool {
        
        guard let items else { return false }
        
        return items.contains(where: { $0.bag == nil })
    }
    
    static func copy(from source: PackingList) -> PackingList {
        let copyList = PackingList()
        copyList.name = source.name
        copyList.colorRed = source.colorRed
        copyList.colorGreen = source.colorGreen
        copyList.colorBlue = source.colorBlue
        copyList.tripLength = source.tripLength
        
        source.items?.forEach {
            copyList.items?.append(Item.copy(from: $0))
        }
        
        return copyList
    }
}
