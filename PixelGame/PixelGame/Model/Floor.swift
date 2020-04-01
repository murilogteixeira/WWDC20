//
//  Floor.swift
//  PixelGame
//
//  Created by Murilo Teixeira on 31/03/20.
//  Copyright © 2020 Murilo Teixeira. All rights reserved.
//

import SpriteKit

class Floor: SKSpriteNode {
    convenience init(size: CGSize, position: CGPoint) {
        self.init()
        self.position = position
        self.size = size
        color = .hexadecimal(hex: 0x804D26)
        zPosition = NodesZPosition.elements.rawValue
        physicsBody = SKPhysicsBody(rectangleOf: size)
        physicsBody?.isDynamic = false
        physicsBody?.categoryBitMask = CategoryBitmask.floor.rawValue
        physicsBody?.contactTestBitMask = CategoryBitmask.hero.rawValue
        physicsBody?.collisionBitMask = CategoryBitmask.hero.rawValue
    }
}

