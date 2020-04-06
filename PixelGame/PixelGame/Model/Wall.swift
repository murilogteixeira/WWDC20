//
//  Wall.swift
//  PixelGame
//
//  Created by Murilo Teixeira on 31/03/20.
//  Copyright © 2020 Murilo Teixeira. All rights reserved.
//

import SpriteKit

class Wall: SKNode {
    convenience init(height: CGFloat, positionX: CGFloat) {
        self.init()
        name = NodeName.wall.rawValue
        position = CGPoint(x: positionX, y: 0)
        zPosition = NodesZPosition.elements.rawValue
        physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 1, height: height))
        physicsBody?.isDynamic = false
        physicsBody?.categoryBitMask = CategoryBitmask.wall.rawValue
    }
    
}
