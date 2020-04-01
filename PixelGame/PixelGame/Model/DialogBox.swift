//
//  DialogBox.swift
//  PixelGame
//
//  Created by Murilo Teixeira on 31/03/20.
//  Copyright © 2020 Murilo Teixeira. All rights reserved.
//

import SpriteKit

class DialogBox: SKSpriteNode {
//    var currentTextIndex = 0
//    var textDialog: [String]?
//    var label: SKLabelNode?
////    var dialogContainer: SKSpriteNode?
//    var dialogIsShow = false {
//        didSet {
//            if dialogIsShow {
//                dialogContainer = setupDialogContainer()
//            }
//            else {
//                label = nil
//            }
//        }
//    }
    
    convenience init(position: CGPoint, size: CGFloat, textDialog: [String]?) {
        self.init()
//        self.textDialog = textDialog
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
    
//    func setupDialogContainer() -> SKSpriteNode {
//        let dialogContainer = PixelArtObject(format: dialogContentFormat, size: CGSize(width: 400, height: 400)).objectSpriteNode
//        dialogContainer.setScale(0)
//        dialogContainer.name = NodeName.messageBox.rawValue
//        dialogContainer.zPosition = NodesZPosition.messageBox.rawValue
//        
//        let label = SKLabelNode()
//        label.fontName = "PressStart2P-Regular"
//        label.text = textDialog?[currentTextIndex]
//        label.fontSize = 12
//        label.fontColor = .white
//        label.verticalAlignmentMode = .center
//        label.horizontalAlignmentMode = .center
//        label.lineBreakMode = .byWordWrapping
//        label.numberOfLines = 0
//        label.zPosition = NodesZPosition.label.rawValue
//        dialogContainer.addChild(label)
//        self.label = label
//        return dialogContainer
//    }
    
//    func showDialog(_ show: Bool) {
//        guard !dialogIsShow else {
//            if !show, let dialog = dialogContainer {
//                let fadeOut = SKAction.fadeOut(withDuration: 0.3)
//                let scaleDown = SKAction.scale(to: 0, duration: 0.3)
//                let positionDown = SKAction.moveTo(y: dialog.position.y - 80, duration: 0.3)
//                let remove = SKAction.run {
//                    self.dialogContainer?.removeFromParent()
//                    self.dialogContainer = nil
//                }
//                dialog.run(fadeOut)
//                dialog.run(scaleDown)
//                dialog.run(.sequence([positionDown, remove]))
//                dialogIsShow = false
//            }
//            return
//        }
//        
//        dialogIsShow = true
//        dialogContainer?.setScale(0)
//        dialogContainer?.alpha = 0
//        dialogContainer?.zPosition = NodesZPosition.dialog.rawValue
//        addChild(dialogContainer!)
//        let fadeIn = SKAction.fadeIn(withDuration: 0.3)
//        let scaleUp = SKAction.scale(to: 1, duration: 0.3)
//        let positionUp = SKAction.moveTo(y: dialogContainer!.position.y + 80, duration: 0.3)
//        dialogContainer?.run(fadeIn)
//        dialogContainer?.run(scaleUp)
//        dialogContainer?.run(positionUp)
//    }
    
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
    
    

}

