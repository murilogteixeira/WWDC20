//
//  Door.swift
//  PixelGame
//
//  Created by Murilo Teixeira on 01/04/20.
//  Copyright © 2020 Murilo Teixeira. All rights reserved.
//

import Cocoa
import SpriteKit

public class Door: SKSpriteNode {
    var isShow = false
    var canOpen = false {
        didSet {
            if canOpen {
                TouchBarScene.shared?.stateMachine.enter(ConfirmState.self)
            }
            else {
                TouchBarScene.shared?.stateMachine.enter(IdleState.self)
            }
        }
    }
    
    convenience init(size: CGFloat, position: CGPoint) {
        self.init()
        self.position = position
        self.size = CGSize(width: size, height: size)
        name = NodeName.door.rawValue
        color = .black
        zPosition = NodesZPosition.door.rawValue
        physicsBody = SKPhysicsBody(rectangleOf: self.size)
        physicsBody?.affectedByGravity = false
        physicsBody?.mass = 0.0000000001
                
        setupPhysicsBody()
        
        texture = PixelArtObject(format: format, size: self.size).objectTexture
    }
    
    func setupPhysicsBody() {
        let heroCategory = CategoryBitmask.hero.rawValue
        let doorCategory = CategoryBitmask.door.rawValue
        let noneCategory = CategoryBitmask.none.rawValue

        physicsBody?.categoryBitMask = doorCategory
        physicsBody?.contactTestBitMask = heroCategory
        physicsBody?.collisionBitMask = noneCategory
    }
}

extension Door {
    var y: SKColor { .hexadecimal(0xd2b625) }
    var format: [[SKColor]] {
        [
            [c,c,c,c,b,b,b,b,b,b,c,c,c,c],
            [c,c,b,b,b,b,b,b,b,b,b,b,c,c],
            [c,b,b,b,b,b,b,b,b,b,b,b,b,c],
            [b,b,b,b,b,b,b,b,b,b,b,b,b,b],
            [b,b,b,b,b,b,b,b,b,b,b,b,b,b],
            [b,b,b,b,b,b,b,b,b,b,b,b,b,b],
            [b,b,b,b,b,b,b,b,b,b,b,b,b,b],
            [b,b,b,b,b,b,b,b,b,b,b,b,b,b],
            [b,b,b,b,b,b,b,b,b,b,b,b,b,b],
            [b,b,b,b,b,b,b,b,b,b,b,b,b,b],
            [b,b,y,y,b,b,b,b,b,b,b,b,b,b],
            [b,b,y,y,b,b,b,b,b,b,b,b,b,b],
            [b,b,b,b,b,b,b,b,b,b,b,b,b,b],
            [b,b,b,b,b,b,b,b,b,b,b,b,b,b],
            [b,b,b,b,b,b,b,b,b,b,b,b,b,b],
            [b,b,b,b,b,b,b,b,b,b,b,b,b,b],
            [b,b,b,b,b,b,b,b,b,b,b,b,b,b],
            [b,b,b,b,b,b,b,b,b,b,b,b,b,b],
            [b,b,b,b,b,b,b,b,b,b,b,b,b,b],
            [b,b,b,b,b,b,b,b,b,b,b,b,b,b],
        ]
    }
}
