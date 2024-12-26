//
//  ColorScheme.swift
//  Packet
//
//  Created by Leia Spagnola on 12/25/24.
//

import SwiftUI

enum ColorScheme: Int, CaseIterable {
    case blue = 0
    case green
    case purple
    case yellow
    
    func get1() -> Color {
        switch self {
        case .blue:
            return Color("Blue1")
        default:
            return Color.clear
            
        }
    }
    
    func get2() -> Color {
        switch self {
        case .blue:
            return Color("Blue2")
        default:
            return Color.clear
            
        }
    }
}
