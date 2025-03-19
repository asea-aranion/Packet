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
    case red
    case yellow
    case purple
    case orange
    
    func get1() -> Color {
        switch self {
        case .blue:
            return Color("Blue1")
        case .green:
            return Color("Green1")
        case .red:
            return Color("Red1")
        case .yellow:
            return Color("Yellow1")
        case .purple:
            return Color("Purple1")
        case .orange:
            return Color("Orange1")
            
        }
    }
    
    func get2() -> Color {
        switch self {
        case .blue:
            return Color("Blue2")
        case .green:
            return Color("Green2")
        case .red:
            return Color("Red2")
        case .yellow:
            return Color("Yellow2")
        case .purple:
            return Color("Purple2")
        case .orange:
            return Color("Orange2")
            
        }
    }
}
