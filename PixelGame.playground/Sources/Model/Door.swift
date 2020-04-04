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
    
    convenience init(size: CGSize, position: CGPoint) {
        self.init()
        self.position = position
        self.size = size
        name = NodeName.door.rawValue
        color = .black
        zPosition = NodesZPosition.door.rawValue
        physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: size.width / 4, height: size.height))
        physicsBody?.affectedByGravity = false
        physicsBody?.mass = 0.0000000001
                
        let heroCategory = CategoryBitmask.hero.rawValue
        let doorCategory = CategoryBitmask.door.rawValue
        let noneCategory = CategoryBitmask.none.rawValue

        physicsBody?.categoryBitMask = doorCategory
        physicsBody?.contactTestBitMask = heroCategory
        physicsBody?.collisionBitMask = noneCategory
    }
}
