//
//  Floor.swift
//  PixelGame
//
//  Created by Murilo Teixeira on 31/03/20.
//  Copyright © 2020 Murilo Teixeira. All rights reserved.
//

import SpriteKit

class Floor: SKNode {
    override init() {
        super.init()
        position = CGPoint(x: 0, y: -240)
        physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 720, height: 20))
        physicsBody?.isDynamic = false
        physicsBody?.categoryBitMask = CategoryBitmask.floor.rawValue
        physicsBody?.contactTestBitMask = CategoryBitmask.hero.rawValue
        physicsBody?.collisionBitMask = CategoryBitmask.hero.rawValue
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}

