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
        color = .hexadecimal(0x957359) //804D26
        zPosition = NodesZPosition.floor.rawValue
        physicsBody = SKPhysicsBody(rectangleOf: size)
        physicsBody?.isDynamic = false
                
        let heroCategory = CategoryBitmask.hero.rawValue
        let floorCategory = CategoryBitmask.floor.rawValue
        let collectableCategory = CategoryBitmask.collectable.rawValue

        physicsBody?.categoryBitMask = floorCategory
        physicsBody?.contactTestBitMask = heroCategory | collectableCategory
        physicsBody?.collisionBitMask = heroCategory
    }
}

extension Floor {
    func contact(_ sceneParent: SKSpriteNode, _ heroNode: Floor, object: SKNode) {
        
        let objectName = NodeName(rawValue: object.name!)!
        
        switch objectName {
        case .dialogBox:
//            guard let dialogContainer = (object as? DialogBox)?.dialogContainer else { return }
//            dialogContainer.show(in: sceneParent)
//            object.destroy(fadeOut: 0.2)
            break
        case .bug:
            object.physicsBody = nil
        case .collectable:
            object.physicsBody = nil
        default:
            break
        }
    }
}
