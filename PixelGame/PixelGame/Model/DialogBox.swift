//
//  DialogBox.swift
//  PixelGame
//
//  Created by Murilo Teixeira on 31/03/20.
//  Copyright © 2020 Murilo Teixeira. All rights reserved.
//

import SpriteKit

class DialogBox: SKSpriteNode {
    var dialogContainer: SKSpriteNode?
    var dialogIsShow = false {
        didSet {
            if dialogIsShow {
                dialogContainer = setupDialogContainer()
            }
            else {
                dialogContainer = nil
                label = nil
            }
        }
    }
    var currentTextIndex = 0
    var textDialog: [String]?
    var label: SKLabelNode?
    
    convenience init(position: CGPoint, size: CGFloat, textDialog: [String]?) {
        self.init()
        self.textDialog = textDialog
        self.size = CGSize(width: size, height: size)
        self.position = position
        self.name = NodeName.dialogBox.rawValue
        self.zPosition = NodesZPosition.elements.rawValue
        
        physicsBody = SKPhysicsBody(rectangleOf: self.size)
        physicsBody?.categoryBitMask = CategoryBitmask.dialogBox.rawValue
        physicsBody?.contactTestBitMask = CategoryBitmask.hero.rawValue
        physicsBody?.affectedByGravity = false
        physicsBody?.isDynamic = false
        
        let sprite = PixelArtObject(format: boxFormat, size: self.size).objectSpriteNode
        addChild(sprite)
    }
    
    func setupDialogContainer() -> SKSpriteNode {
        let dialogContainer = PixelArtObject(format: dialogContentFormat, size: CGSize(width: 400, height: 400)).objectSpriteNode
        dialogContainer.setScale(0)
        dialogContainer.name = NodeName.messageBox.rawValue
        dialogContainer.zPosition = NodesZPosition.messageBox.rawValue
        
        let label = SKLabelNode()
        label.fontName = "PressStart2P-Regular"
        label.text = textDialog?[currentTextIndex]
        label.fontSize = 12
        label.fontColor = .white
        label.verticalAlignmentMode = .center
        label.horizontalAlignmentMode = .center
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        label.zPosition = NodesZPosition.label.rawValue
        dialogContainer.addChild(label)
        self.label = label
        return dialogContainer
    }
    
    func showDialog(_ show: Bool = true) {
        guard !dialogIsShow else {
            if !show, let dialog = dialogContainer {
                let scaleDown = SKAction.scale(to: 0, duration: 0.3)
                let positionDown = SKAction.moveTo(y: dialog.position.y - 80, duration: 0.3)
                let remove = SKAction.run {
                    self.dialogContainer?.removeFromParent()
                }
                dialog.run(scaleDown)
                dialog.run(.sequence([positionDown, remove]))
                
                dialogIsShow = false
            }
            return
        }
        
        dialogIsShow = true
        dialogContainer?.setScale(0)
//        dialogContainer = MessageBox(text: text, position: .zero, size: CGSize(width: 400, height: 400))
        dialogContainer?.zPosition = NodesZPosition.dialog.rawValue
        addChild(dialogContainer!)
        let scaleUp = SKAction.scale(to: 1, duration: 0.3)
        let positionUp = SKAction.moveTo(y: dialogContainer!.position.y + 80, duration: 0.3)
        dialogContainer?.run(scaleUp)
        dialogContainer?.run(positionUp)
        
    }
    
    func contact() {
        physicsBody?.applyImpulse(CGVector(dx: 0, dy: 10))
    }
}

extension DialogBox {
    var boxFormat: [[NSColor]] {
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
    
    var dialogContentFormat: [[NSColor]] {
        [
            [c,c,c,c,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,c,c,c,c],
            [c,c,b,b,d,d,d,d,d,d,d,d,d,d,d,d,d,d,d,d,d,d,d,d,d,d,d,d,d,d,d,d,d,d,d,d,d,d,d,d,d,d,d,d,b,b,c,c],
            [c,b,d,d,l,l,l,l,l,l,l,l,l,l,l,l,l,l,l,l,l,l,l,l,l,l,l,l,l,l,l,l,l,l,l,l,l,l,l,l,l,l,l,l,d,d,b,c],
            [c,b,d,l,d,d,d,d,d,d,d,d,d,d,d,d,d,d,d,d,d,d,d,d,d,d,d,d,d,d,d,d,d,d,d,d,d,d,d,d,d,d,d,d,l,d,b,c],
            [b,d,l,d,d,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,d,d,l,d,b],
            [b,d,l,d,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,d,l,d,b],
            [b,d,l,d,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,d,l,d,b],
            [b,d,l,d,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,d,l,d,b],
            [b,d,l,d,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,d,l,d,b],
            [b,d,l,d,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,d,l,d,b],
            [b,d,l,d,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,d,l,d,b],
            [b,d,l,d,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,d,l,d,b],
            [b,d,l,d,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,d,l,d,b],
            [b,d,l,d,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,d,l,d,b],
            [b,d,l,d,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,d,l,d,b],
            [b,d,l,d,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,d,l,d,b],
            [b,d,l,d,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,d,l,d,b],
            [b,d,l,d,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,d,l,d,b],
            [b,d,l,d,d,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,d,d,l,d,b],
            [c,b,d,l,d,d,d,d,d,d,d,d,d,d,d,d,d,d,d,d,d,d,d,d,d,d,d,d,d,d,d,d,d,d,d,d,d,d,d,d,d,d,d,d,l,d,b,c],
            [c,b,d,d,l,l,l,l,l,l,l,l,l,l,l,l,l,l,l,l,l,l,l,l,l,l,l,l,l,l,l,l,l,l,l,l,l,l,l,l,l,l,l,l,d,d,b,c],
            [c,c,b,b,d,d,d,d,d,d,d,d,d,d,d,d,d,d,d,d,d,d,d,d,d,d,d,d,d,d,d,d,d,d,d,d,d,d,d,d,d,d,d,d,b,b,c,c],
            [c,c,c,c,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,c,c,c,c],
        ]
    }

}

