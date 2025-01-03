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
    var colorRed: Double = 71 / 255
    var colorGreen: Double = 159 / 255
    var colorBlue: Double = 211 / 255
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
