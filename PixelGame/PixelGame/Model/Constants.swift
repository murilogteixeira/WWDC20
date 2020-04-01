//
//  Constants.swift
//  PixelGame
//
//  Created by Murilo Teixeira on 31/03/20.
//  Copyright © 2020 Murilo Teixeira. All rights reserved.
//

import SpriteKit

enum CategoryBitmask: UInt32 {
    case hero, enemy, floor, wall, dialogBox
}

enum NodeName: String {
    case hero = "hero"
    case enemy = "enemy"
    case floor = "floor"
    case wall = "wall"
    case dialogBox = "dialogBox"
    case messageBox = "messageBox"
    case background = "background"
    case controlNode = "controlNode"
}

enum NodesZPosition: CGFloat {
    case background, controlNode, elements, character, dialog, messageBox, label
}

let c = NSColor.clear
let b = NSColor.black
let w = NSColor.white
let d = NSColor.darkGray
let l = NSColor.lightGray
let g = NSColor.hexadecimal(hex: 0xf6b73d)

public struct Constants {
    public struct Character {
        
    }
    
    public struct Elements {
        static let MessageBox = [
            [c,c,c,c,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,c,c,c,c],
            [c,c,b,b,d,d,d,d,d,d,d,d,d,d,d,d,d,d,d,d,d,d,d,d,d,d,d,d,d,b,b,c,c],
            [c,b,d,d,l,l,l,l,l,l,l,l,l,l,l,l,l,l,l,l,l,l,l,l,l,l,l,l,l,d,d,b,c],
            [c,b,d,l,d,d,d,d,d,d,d,d,d,d,d,d,d,d,d,d,d,d,d,d,d,d,d,d,d,l,d,b,c],
            [b,d,l,d,d,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,d,d,l,d,b],
            [b,d,l,d,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,d,l,d,b],
            [b,d,l,d,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,d,l,d,b],
            [b,d,l,d,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,d,l,d,b],
            [b,d,l,d,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,d,l,d,b],
            [b,d,l,d,d,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,d,d,l,d,b],
            [c,b,d,l,d,d,d,d,d,d,d,d,d,d,d,d,d,d,d,d,d,d,d,d,d,d,d,d,d,l,d,b,c],
            [c,b,d,d,l,l,l,l,l,l,l,l,l,l,l,l,l,l,l,l,l,l,l,l,l,l,l,l,l,d,d,b,c],
            [c,c,b,b,d,d,d,d,d,d,d,d,d,d,d,d,d,d,d,d,d,d,d,d,d,d,d,d,d,b,b,c,c],
            [c,c,c,c,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,c,c,c,c],
        ]
    }
}

let heart: [[NSColor]] = {
    let b = NSColor.white
    let f = NSColor.red
    let c = NSColor.clear
    return [
        [c,c,b,c,c,c,b,c,c],
        [c,b,f,b,c,b,f,b,c],
        [b,f,f,f,b,f,f,f,b],
        [c,b,f,f,f,f,f,b,c],
        [c,c,b,f,f,f,b,c,c],
        [c,c,c,b,f,b,c,c,c],
        [c,c,c,c,b,c,c,c,c]
    ]
}()

