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
        name = NodeName.floor.rawValue
        color = .hexadecimal(hex: 0x957359) //804D26
        zPosition = NodesZPosition.floor.rawValue
        physicsBody = SKPhysicsBody(rectangleOf: size)
        physicsBody?.isDynamic = false
                
        let heroCategory = CategoryBitmask.hero.rawValue
        let floorCategory = CategoryBitmask.floor.rawValue
        
        physicsBody?.categoryBitMask = floorCategory
        physicsBody?.contactTestBitMask = heroCategory
        physicsBody?.collisionBitMask = heroCategory
    }
}

