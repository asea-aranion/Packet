//
//  ColorScheme.swift
//  Packet
//
//  Created by Leia Spagnola on 12/25/24.
//

import SwiftUI

enum Theme: Int, CaseIterable {
    case blue = 0
    case green
    case purple
    case yellow
    
    func get1() -> Color {
        switch self {
        case .blue:
            return Color("Blue1")
        case .green:
            return Color("Green1")
        default:
            return Color.clear
            
        }
    }
    
    func get2() -> Color {
        switch self {
        case .blue:
            return Color("Blue2")
        case .green:
            return Color("Green2")
        default:
            return Color.clear
            
        }
    }
}
