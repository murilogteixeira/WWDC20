//
//  Wall.swift
//  PixelGame
//
//  Created by Murilo Teixeira on 31/03/20.
//  Copyright © 2020 Murilo Teixeira. All rights reserved.
//

import SpriteKit

class Wall: SKNode {
    override init() {
        super.init()
        physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 1, height: 480))
        physicsBody?.isDynamic = false
        physicsBody?.categoryBitMask = CategoryBitmask.wall.rawValue
//        physicsBody?.contactTestBitMask = CategoryBitmask.hero.rawValue
//        physicsBody?.collisionBitMask = CategoryBitmask.hero.rawValue
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
