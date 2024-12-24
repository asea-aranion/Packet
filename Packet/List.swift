//
//  List.swift
//  Packet
//
//  Created by Leia Spagnola on 12/23/24.
//

import SwiftData
import SwiftUI

@Model
class List {
    
    var name: String = "New Packing List"
    var colorRed: Double = 0.5
    var colorGreen: Double = 0.5
    var colorBlue: Double = 0.5
    @Relationship(deleteRule: .cascade) var items: [Item]?
    var tripLength: Int = 1
    
    init() {
        items = [Item]()
    }
    
    static func copy(from source: List) -> List {
        let copyList = List()
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
