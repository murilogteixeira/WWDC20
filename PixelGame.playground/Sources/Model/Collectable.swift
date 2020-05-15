//
//  Collectable.swift
//  PixelGame
//
//  Created by Murilo Teixeira on 04/04/20.
//  Copyright © 2020 Murilo Teixeira. All rights reserved.
//

import SpriteKit

public class Collectable: SKSpriteNode {
    convenience init(position: CGPoint) {
        self.init()
        self.position = position
        size = CGSize(width: 45, height: 45)
        name = NodeName.collectable.rawValue
        zPosition = NodesZPosition.codeBlock.rawValue
//        color = .green
        
        
        setupPhysicsBody()
        
        let texture = PixelArtObject(format: format, size: size).objectTexture
        self.texture = texture
    }
    
    func setupPhysicsBody() {
        physicsBody = SKPhysicsBody(circleOfRadius: (size.width / 2) * 0.7)
        physicsBody?.affectedByGravity = false
        physicsBody?.mass = 0.000000001
                
        let collectableCategory = CategoryBitmask.collectable.rawValue
        let heroCategory = CategoryBitmask.hero.rawValue
        let floorCategory = CategoryBitmask.floor.rawValue
        let noneCategory = CategoryBitmask.none.rawValue

        physicsBody?.categoryBitMask = collectableCategory
        physicsBody?.contactTestBitMask = heroCategory | floorCategory
        physicsBody?.collisionBitMask = noneCategory
    }
}

extension Collectable {
    var s: SKColor { .hexadecimal(0xf4720b) }
    var v: SKColor { .hexadecimal(0x4A963D) }
    var format: [[SKColor]] {
        [
            [c,c,c,c,c,c,c,c,c,c,c,c,c,c,c,c,c,c,c,c,s,c,c,c,c,c,c,c,c,c,c,c,c,c,c],
            [c,c,c,c,c,c,c,c,c,c,s,c,c,c,c,c,c,c,c,c,s,s,c,c,c,c,c,c,c,c,c,c,c,c,c],
            [c,c,c,c,c,c,c,s,c,c,c,s,c,c,c,c,c,c,c,c,c,s,s,c,c,c,c,c,c,c,c,c,c,c,c],
            [c,c,c,c,c,c,c,c,s,c,c,s,s,c,c,c,c,c,c,c,c,s,s,s,c,c,c,c,c,c,c,c,c,c,c],
            [c,c,c,c,c,c,c,c,s,s,c,c,s,s,c,c,c,c,c,c,c,c,s,s,s,c,c,c,c,c,c,c,c,c,c],
            [c,c,c,c,c,c,c,c,c,s,s,c,c,s,s,c,c,c,c,c,c,c,s,s,s,s,c,c,c,c,c,c,c,c,c],
            [c,c,c,c,c,c,c,c,c,c,s,s,c,c,s,s,c,c,c,c,c,c,c,s,s,s,c,c,c,c,c,c,c,c,c],
            [c,c,c,c,c,c,c,c,c,c,c,s,s,c,c,s,s,c,c,c,c,c,c,s,s,s,s,c,c,c,c,c,c,c,c],
            [v,v,v,v,c,c,c,c,c,c,c,c,s,s,c,c,s,s,c,c,c,c,s,s,s,s,s,c,c,c,c,v,v,v,v],
            [v,v,v,v,c,c,c,c,c,c,c,c,c,s,s,c,c,s,s,c,c,c,s,s,s,s,s,s,c,c,c,v,v,v,v],
            [v,v,c,c,c,c,c,c,c,c,c,c,c,c,s,s,s,s,s,s,c,c,s,s,s,s,s,s,c,c,c,c,c,v,v],
            [v,v,c,c,c,c,c,c,c,c,c,c,c,c,c,s,s,s,s,s,s,s,s,s,s,s,s,s,c,c,c,c,c,v,v],
            [v,v,c,c,c,c,c,c,c,c,c,c,c,c,c,c,s,s,s,s,s,s,s,s,s,s,s,c,c,c,c,c,c,v,v],
            [v,v,c,c,c,c,s,c,c,c,c,c,c,c,c,c,c,s,s,s,s,s,s,s,s,s,s,c,c,c,c,c,c,v,v],
            [v,v,c,c,c,c,c,s,s,c,c,c,c,c,c,c,c,c,s,s,s,s,s,s,s,s,c,c,c,c,c,c,c,v,v],
            [v,v,v,v,c,c,c,s,s,s,s,s,c,c,c,c,c,s,s,s,s,s,s,s,s,s,s,s,c,c,c,v,v,v,v],
            [v,v,v,v,c,c,c,c,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,c,c,c,v,v,v,v],
            [c,c,c,c,c,c,c,c,c,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,c,c,c,c,c,c],
            [c,c,c,c,c,c,c,c,c,c,c,s,s,s,s,s,s,s,s,s,s,s,s,s,c,c,s,s,s,c,c,c,c,c,c],
            [c,c,c,c,c,c,c,c,c,c,c,c,s,s,s,s,s,s,s,s,s,s,c,c,c,c,c,s,s,c,c,c,c,c,c],
            [c,c,c,c,c,c,c,c,c,c,c,c,c,c,s,s,s,s,s,c,c,c,c,c,c,c,c,c,s,c,c,c,c,c,c],
        ]
    }
}
