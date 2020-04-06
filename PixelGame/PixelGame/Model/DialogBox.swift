//
//  DialogBox.swift
//  PixelGame
//
//  Created by Murilo Teixeira on 31/03/20.
//  Copyright © 2020 Murilo Teixeira. All rights reserved.
//

import SpriteKit

class DialogBox: SKSpriteNode {
    
    unowned var sceneParent: SKSpriteNode!
    weak var dialogContainer: DialogMessageContainer?
    
    convenience init(_ scene: SKSpriteNode, position: CGPoint, size: CGFloat) {
        self.init()
        self.sceneParent = scene
        self.size = CGSize(width: size, height: size)
        self.position = position
        self.name = NodeName.dialogBox.rawValue
        self.zPosition = NodesZPosition.elements.rawValue
        
        setupPhysicsBody()
        
        let texture = PixelArtObject(format: boxFormat, size: self.size).objectTexture
        self.texture = texture
    }
    
    func setupPhysicsBody() {
        let dialogCategory = CategoryBitmask.dialogBox.rawValue
        let heroCategory = CategoryBitmask.hero.rawValue
        let floorCategory = CategoryBitmask.floor.rawValue
        let noneCategory = CategoryBitmask.none.rawValue

        physicsBody = SKPhysicsBody(rectangleOf: self.size)
        physicsBody?.categoryBitMask = dialogCategory
        physicsBody?.contactTestBitMask = heroCategory | floorCategory
        physicsBody?.collisionBitMask = noneCategory
        physicsBody?.affectedByGravity = false
        physicsBody?.allowsRotation = false
    }
    
    
}

// MARK: Handle Physic Contact
extension DialogBox {
    func contact(_ scene: SKSpriteNode, _ dialogBox: SKNode, with object: SKNode) {
        
        guard let dialogContainer = dialogContainer else { return }
        
        dialogBox.destroy(fadeOut: 0.4)
        
        if object.name == NodeName.hero.rawValue {

            dialogContainer.show(in: sceneParent)
            
            if GameScene.shared.stateMachine.currentState is GameState {
                print("teste")
            }
            
        }
        
    }
}

//MARK: Format
extension DialogBox {
    var boxFormat: [[SKColor]] {
        [
            [c,c,b,b,b,b,b,b,b,b,b,b,b,b,c,c],
            [c,b,g,g,g,g,g,g,g,g,g,g,g,g,b,c],
            [b,g,g,g,b,b,b,b,b,b,b,b,g,g,g,b],
            [b,g,g,b,w,w,w,w,w,w,w,w,b,g,g,b],
            [b,g,b,w,w,w,w,w,w,w,w,w,w,b,g,b],
            [b,g,b,w,w,w,b,b,b,b,w,w,w,b,g,b],
            [b,g,b,w,w,w,b,b,b,b,w,w,w,b,g,b],
            [b,g,g,b,b,b,b,w,w,w,w,w,b,g,g,b],
            [b,g,g,g,g,g,b,w,w,w,b,b,g,g,g,b],
            [b,g,g,g,g,g,b,w,w,b,g,g,g,g,g,b],
            [b,g,g,g,g,g,g,b,b,g,g,g,g,g,g,b],
            [b,g,g,g,g,g,b,w,w,b,g,g,g,g,g,b],
            [b,g,g,g,g,g,b,w,w,b,g,g,g,g,g,b],
            [b,g,g,g,g,g,g,b,b,g,g,g,g,g,g,b],
            [c,b,g,g,g,g,g,g,g,g,g,g,g,g,b,c],
            [c,c,b,b,b,b,b,b,b,b,b,b,b,b,c,c],
        ]
    }
    
    

}

