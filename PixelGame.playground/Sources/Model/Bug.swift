//
//  Bug.swift
//  PixelGame
//
//  Created by Murilo Teixeira on 04/04/20.
//  Copyright © 2020 Murilo Teixeira. All rights reserved.
//

import SpriteKit

public class Bug: SKSpriteNode {
    convenience init(position: CGPoint) {
        self.init()
        self.position = position
        size = CGSize(width: 45, height: 45)
        name = NodeName.bug.rawValue
        zPosition = NodesZPosition.bug.rawValue
        
        setupPhysicsBody()
        
        let texture = PixelArtObject(format: format, size: size).objectTexture
        self.texture = texture
    }
    
    func setupPhysicsBody() {
        physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: size.width * 0.8, height: size.height))
        physicsBody?.affectedByGravity = false
        physicsBody?.mass = 0.000000001
                
        let bugCategory = CategoryBitmask.bug.rawValue
        let heroCategory = CategoryBitmask.hero.rawValue
        let floorCategory = CategoryBitmask.floor.rawValue
        let noneCategory = CategoryBitmask.none.rawValue

        physicsBody?.categoryBitMask = bugCategory
        physicsBody?.contactTestBitMask = heroCategory | floorCategory
        physicsBody?.collisionBitMask = noneCategory
    }
}

extension Bug {
//    func contact(_ sceneParent: SKSpriteNode, _ collectable: SKNode, with object: SKNode) {
//        
//        if object.name == NodeName.hero.rawValue {
//            collectable.destroy(fadeOut: 0.1)
//        }
//        else if object.name == NodeName.floor.rawValue {
//            collectable.destroy(fadeOut: 0.3)
//        }
//    }
    
}

extension Bug {
    var r: SKColor { .red }
    var format: [[SKColor]] {
        [
            [c,c,c,c,c,c,c,c,b,c,c,b,c,c,c,c,c,c,c,c],
            [c,c,c,c,c,c,c,b,c,c,c,c,b,c,c,c,c,c,c,c],
            [c,c,c,c,c,c,b,c,c,c,c,c,c,b,c,c,c,c,c,c],
            [c,c,c,c,c,c,b,c,c,c,c,c,c,b,c,c,c,c,c,c],
            [c,c,c,c,c,c,c,b,c,c,c,c,b,c,c,c,c,c,c,c],
            [c,c,c,c,b,c,c,b,c,c,c,c,b,c,c,b,c,c,c,c],
            [c,b,c,c,b,c,c,c,b,c,c,b,c,c,c,b,c,c,b,c],
            [c,c,b,c,c,b,b,c,b,c,c,b,c,b,b,c,c,b,c,c],
            [c,c,b,c,c,c,c,b,c,b,b,c,b,c,c,c,c,b,c,c],
            [c,c,b,c,c,c,c,c,b,b,b,b,c,c,c,c,c,b,c,c],
            [c,c,c,b,c,c,c,r,b,b,b,b,r,c,c,c,b,c,c,c],
            [c,c,c,b,c,c,b,r,r,b,b,r,r,b,c,c,b,c,c,c],
            [c,c,c,b,c,c,b,b,b,b,b,b,b,b,c,c,b,c,c,c],
            [c,c,c,c,b,b,b,b,r,r,r,r,b,b,b,b,c,c,c,c],
            [c,c,c,c,c,c,c,b,r,b,b,r,b,c,c,c,c,c,c,c],
            [c,c,c,c,c,c,b,b,b,b,b,b,b,b,c,c,c,c,c,c],
            [c,c,c,c,c,c,b,b,b,b,b,b,b,b,c,c,c,c,c,c],
            [c,c,c,c,b,b,b,b,b,b,b,b,b,b,b,b,c,c,c,c],
            [c,c,b,b,b,c,b,b,b,b,b,b,b,b,c,b,b,b,c,c],
            [c,b,b,c,c,c,b,b,b,b,b,b,b,b,c,c,c,b,b,c],
            [c,b,c,c,b,b,b,b,b,b,b,b,b,b,b,b,c,c,b,c],
            [c,b,c,c,b,c,c,b,b,b,b,b,b,c,c,b,c,c,b,c],
            [b,b,c,c,b,c,c,c,b,b,b,b,c,c,c,b,c,c,b,b],
            [b,c,c,c,b,c,c,c,c,c,c,c,c,c,c,b,c,c,c,b],
            [c,c,c,c,c,b,c,c,c,c,c,c,c,c,b,c,c,c,c,c],
            [c,c,c,c,c,b,c,c,c,c,c,c,c,c,b,c,c,c,c,c],
            [c,c,c,c,c,b,c,c,c,c,c,c,c,c,b,c,c,c,c,c],
            [c,c,c,c,b,c,c,c,c,c,c,c,c,c,c,b,c,c,c,c],
            [c,c,c,c,b,c,c,c,c,c,c,c,c,c,c,b,c,c,c,c],
            [c,c,c,c,b,c,c,c,c,c,c,c,c,c,c,b,c,c,c,c],
        ]
    }
}
