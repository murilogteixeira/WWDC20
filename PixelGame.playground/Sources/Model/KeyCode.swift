//
//  Key.swift
//  PixelGame
//
//  Created by Murilo Teixeira on 31/03/20.
//  Copyright © 2020 Murilo Teixeira. All rights reserved.
//

import Foundation

enum KeyCode: UInt16 {
    case none = 999
    case left = 123
    case right = 124
    case down = 125
    case up = 126
    case enter = 36
    
    var description: String {
        switch self {
        case .left:
            return "left"
        case .right:
            return "right"
        case .down:
            return "down"
        case .up:
            return "up"
        case .enter:
            return "return"
        default:
            return "unknow"
        }
    }
}

struct Key {
    var active: Bool = true
    var pressed: Bool
    var busy: Bool
    var name: KeyCode
}
