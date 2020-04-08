//
//  DialogMessageContainer.swift
//  PixelGame
//
//  Created by Murilo Teixeira on 01/04/20.
//  Copyright © 2020 Murilo Teixeira. All rights reserved.
//

import Cocoa
import SpriteKit

class DialogMessageContainer: SKSpriteNode {
    private var _subscriberName: String!
    
    var textDialog = [String]()
    var currentTextIndex = 0
    
    lazy var label: SKLabelNode = {
        let label = SKLabelNode()
        label.fontName = kFontName
        label.fontSize = 12
        label.fontColor = .white
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        label.verticalAlignmentMode = .center
        label.horizontalAlignmentMode = .center
        label.preferredMaxLayoutWidth = self.size.width
        label.zPosition = NodesZPosition.label.rawValue
        label.name = NodeName.label.rawValue
        return label
    }()
    
    var isShow = false
    
    convenience init(position: CGPoint, size: CGFloat, textDialog: [String], name: String) {
        self.init()
        self.subscriberName = name
        self.textDialog = textDialog
//        self.size = CGSize(width: size, height: size)
        self.position = position
        
//        texture = PixelArtObject(format: format, size: self.size).objectTexture
        color = .black
        
        self.name = NodeName.messageBox.rawValue
        zPosition = NodesZPosition.messageBox.rawValue
        
        label.text = textDialog[currentTextIndex]
        self.addChild(label)
        
//        let proportionWidth: CGFloat = 1.2
//        let proportionHeight: CGFloat = 1.3
//        self.size = CGSize(width: label.frame.size.width * proportionWidth, height: label.frame.size.height * proportionHeight)
                
        updateSize()
        
        setScale(0)
    }
    
}

// MARK: Show/Hidde Dialog Message Container
extension DialogMessageContainer {
    func show(in scene: SKSpriteNode) {
        TouchBarView.manager.add(subscriber: self)
        if TouchBarScene.showAlert {
            TouchBarScene.shared?.stateMachine.enter(AlertState.self)
            TouchBarScene.showAlert = false
        }
        else {
            TouchBarScene.shared?.stateMachine.enter(DialogMenuState.self)
        }
        
        currentTextIndex = 0
        label.text = textDialog[currentTextIndex]
        isShow = true
        alpha = 0
        zPosition = NodesZPosition.dialog.rawValue
        scene.addChild(self)
        let wait: SKAction = .wait(forDuration: 0.3)
        let fadeIn = SKAction.fadeIn(withDuration: 0.3)
        let scaleUp = SKAction.scale(to: 1, duration: 0.3)

        run(.sequence([wait, fadeIn]))
        run(.sequence([wait, scaleUp]))
        
        validateButtons()
    }
    
    func hidde() {
        TouchBarView.manager.remove(subscriber: self)

        let fadeOut = SKAction.fadeOut(withDuration: 0.3)
        let scaleDown = SKAction.scale(to: 0, duration: 0.3)
        let remove = SKAction.run { [weak self] in
            self?.removeFromParent()
        }
        run(fadeOut)
        run(.sequence([scaleDown, remove]))
        isShow = false
    }
    
    func updateSize() {
        let proportionWidth: CGFloat = 1.2
        let proportionHeight: CGFloat = 1.4
        self.size = CGSize(width: label.frame.size.width + 80, height: label.frame.size.height + 80)
    }
}

//MARK: TouchBarSubscriber
extension DialogMessageContainer: TouchBarSubscriber {
    var subscriberName: String {
        get {
            self._subscriberName
        }
        set {
            self._subscriberName = newValue
        }
    }
    
    
    func buttonTapped(_ notificationType: TouchBarNotificationType, with button: NSButton? = nil) {
        switch notificationType {
        case .prevButton:
            if currentTextIndex > 0 {
                currentTextIndex -= 1
                label.text = textDialog[currentTextIndex]
            }
        case .nextButton:
            if currentTextIndex < textDialog.count-1 {
                currentTextIndex += 1
                label.text = textDialog[currentTextIndex]
            }
        case . closeButton:
            hidde()
        default:
            break
        }
        updateSize()
        validateButtons()
    }
    
    func validateButtons() {
        
        if let dialogMenuState = TouchBarScene.shared?.stateMachine.currentState as? DialogMenuState {
            if textDialog.count == 1 {
                dialogMenuState.prevButton.isEnabled = false
                dialogMenuState.nextButton.isEnabled = false
                dialogMenuState.closeButton.isEnabled = true
            }
            else if currentTextIndex == 0 {
                dialogMenuState.prevButton.isEnabled = false
                dialogMenuState.nextButton.isEnabled = true
                dialogMenuState.closeButton.isEnabled = false
            }
            else if currentTextIndex == textDialog.count - 1 {
                dialogMenuState.prevButton.isEnabled = true
                dialogMenuState.nextButton.isEnabled = false
                dialogMenuState.closeButton.isEnabled = true
            }
            else {
                dialogMenuState.prevButton.isEnabled = true
                dialogMenuState.nextButton.isEnabled = true
                dialogMenuState.closeButton.isEnabled = false
            }
        }
    }
    
    override var description: String { "DialogMessageContainer" }
}

//MARK: Format
extension DialogMessageContainer {
    var format: [[SKColor]] {
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
    
    func showVisualFormat() {
        var formatString = String()
        for _ in 0..<format.count {
            for _ in 0..<format.first!.count {
                formatString.append(".")
            }
            formatString.append("\n")
        }
        print(formatString, separator: " ", terminator: "")
    }
}
