//
//  Key.swift
//  PixelGame
//
//  Created by Murilo Teixeira on 31/03/20.
//  Copyright © 2020 Murilo Teixeira. All rights reserved.
//

import Foundation

enum KeyName: UInt16 {
    case none = 999
    case left = 123
    case right = 124
    case down = 125
    case up = 126
    case enter = 36
}

struct Key {
    var active: Bool = true
    var pressed: Bool
    var busy: Bool
    var name: KeyName
}
