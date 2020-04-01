//
//  TouchBarIntroState.swift
//  PixelGame
//
//  Created by Murilo Teixeira on 31/03/20.
//  Copyright © 2020 Murilo Teixeira. All rights reserved.
//

import Cocoa
import SpriteKit
import GameplayKit

class IntroState: GKState {
    unowned let gameScene: GameScene
    var controlNode: SKNode!
    var scene: SKSpriteNode!
    
    lazy var floor = Floor(size: CGSize(width: self.scene.frame.size.width, height: self.scene.frame.height * 0.15),
                           position: CGPoint(x: 0, y: -self.scene.size.height / 2))
    lazy var leftWall = Wall(height: self.scene.size.height, positionX: -self.scene.size.width / 2)
    lazy var rightWall = Wall(height: self.scene.size.height, positionX: self.scene.size.width / 2)
    
    lazy var hero: Hero = {
        let hero = Hero(size: 80)
        self.gameScene.add(subscriber: hero)
        return hero
    }()
    
    lazy var dialogBox: DialogBox = {
        let textDialog = [
            """
            Aqui aparecerão as dicas e
            desafios a serem cumpridos

            As ações podem ser
            controladas pelos botões
            na TouchBar.
            """,
            """
            Caso o seu dispositivo não
            possua TouchBar basta
            pressionar cmd+shift+8.
            """,
            "Teste1",
            "Teste2"
        ]
        let boxSize: CGFloat = 30
        let widthScene = (self.scene.size.width / 2) - boxSize
        let heightScene = -self.scene.size.width / 2
        let position = CGPoint(x: CGFloat.random(in: -widthScene..<widthScene), y: (self.scene.size.height / 2) + boxSize)
        let node = DialogBox(position: position, size: boxSize, textDialog: textDialog)
        node.run(.moveTo(y: heightScene, duration: 5))
        return node
    }()
    
    lazy var dialogContainer: DialogMessageContainer? = {
        let textDialog = [
            """
            Aqui aparecerão as dicas e
            desafios a serem cumpridos

            As ações podem ser
            controladas pelos botões
            na TouchBar.
            """,
            """
            Caso o seu dispositivo não
            possua TouchBar basta
            pressionar cmd+shift+8.
            """,
            "Teste1",
            "Teste2"
        ]
        let node = DialogMessageContainer(position: .zero, size: 400, textDialog: textDialog)
        return node
    }()
    
    lazy var door: SKSpriteNode = {
        let node = Door(color: .black, size: CGSize(width: 100, height: 200))
        return node
    }()
    
    lazy var windowController: WindowController? = {
        if let mainWindow = NSApplication.shared.mainWindow,
            let windowController = mainWindow.windowController as? WindowController {
            return windowController
        }
        return nil
    }()
    
    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        switch stateClass {
        case is GameState.Type:
            return true
        default:
            return false
        }
    }
    
    override func didEnter(from previousState: GKState?) {
        controlNode = gameScene.controlNode
        
        scene = buildScene()
        controlNode?.addChild(scene)
                
        scene.addChild(hero)
        scene.addChild(floor)
        scene.addChild(leftWall)
        scene.addChild(rightWall)
        scene.addChild(dialogBox)
        
        scene.run(.fadeAlpha(to: 1.0, duration: 0.4))
    }
    
    override func willExit(to nextState: GKState) {
        self.scene.removeAllChildren()
        self.scene.removeFromParent()
        self.controlNode = nil
        self.scene = nil
    }
    
    override func update(deltaTime seconds: TimeInterval) {
        hero.move(direction: gameScene.directionPressed)
    }
    
    func buildScene() -> SKSpriteNode {
        let node = SKSpriteNode()
        node.color = .hexadecimal(hex: 0xC9FFFD)
        node.size = gameScene.size
        node.zPosition = NodesZPosition.background.rawValue
        node.name = NodeName.background.rawValue
        node.alpha = 0
        return node
    }
    
    init(gameScene: GameScene) {
        self.gameScene = gameScene
        super.init()
        self.gameScene.physicsWorld.contactDelegate = self
    }
}

extension IntroState {
    func showDialogContainer(_ show: Bool) {
        guard show, let dialogConteiner = dialogContainer, !dialogConteiner.dialogIsShow else {
            if !show, let dialog = dialogContainer {
                let fadeOut = SKAction.fadeOut(withDuration: 0.3)
                let scaleDown = SKAction.scale(to: 0, duration: 0.3)
                let positionDown = SKAction.moveTo(y: dialog.position.y - 80, duration: 0.3)
                let remove = SKAction.run {
                    self.dialogContainer?.removeFromParent()
                    self.dialogContainer = nil
                }
                dialog.run(fadeOut)
                dialog.run(scaleDown)
                dialog.run(.sequence([positionDown, remove]))
                dialogContainer?.dialogIsShow = false
            }
            return
        }
        
        dialogContainer?.dialogIsShow = true
        dialogContainer?.alpha = 0
        dialogContainer?.zPosition = NodesZPosition.dialog.rawValue
        scene.addChild(dialogContainer!)
        let fadeIn = SKAction.fadeIn(withDuration: 0.3)
        let scaleUp = SKAction.scale(to: 1, duration: 0.3)
//        let positionUp = SKAction.moveTo(y: dialogContainer!.position.y + 80, duration: 0.3)
        dialogContainer?.run(fadeIn)
        dialogContainer?.run(scaleUp)
//        dialogContainer?.run(positionUp)
    }
}

//MARK: SKPhysicsContactDelegate
extension IntroState: SKPhysicsContactDelegate {
    func didBegin(_ contact: SKPhysicsContact) {
        let heroCategory = CategoryBitmask.hero.rawValue
        let floorCategory = CategoryBitmask.floor.rawValue
        let dialogBoxCategory = CategoryBitmask.dialogBox.rawValue
        // Contact Hero with Floor
        if ((contact.bodyA.categoryBitMask == heroCategory) && (contact.bodyB.categoryBitMask == floorCategory)) || ((contact.bodyA.categoryBitMask == floorCategory) && (contact.bodyB.categoryBitMask == heroCategory)) {

            hero.isOnTheFloor = true
            gameScene.upKey.busy = false
            
            if hero.isOnTheFloor {
                hero.walking = hero.isWalking
            }
        }
        else if ((contact.bodyA.categoryBitMask == heroCategory) && (contact.bodyB.categoryBitMask == dialogBoxCategory)) {
            dialogBox.contact()
            dialogContainer?.currentTextIndex = 0
            showDialogContainer(true)
            windowController?.customTouchBar = makeTouchBar()
        }
    }
}

// MARK: Make TouchBar
extension IntroState {
    func makeTouchBar() -> NSTouchBar? {
        let touchBar = NSTouchBar()
        touchBar.delegate = self
        touchBar.customizationIdentifier = .touchBarIdentifier
        
        let button1: NSTouchBarItem.Identifier = dialogContainer?.currentTextIndex == 0 ? .button1Disable : .button1
        let button2: NSTouchBarItem.Identifier = dialogContainer?.currentTextIndex == dialogContainer!.textDialog.count - 1 ? .button2Disable : .button2
        let button3: NSTouchBarItem.Identifier = dialogContainer?.currentTextIndex == dialogContainer!.textDialog.count - 1 ? .button3 : .button3Disable

            touchBar.defaultItemIdentifiers = [.flexibleSpace, .infoLabelItem, .flexibleSpace, button1, button2, button3, .flexibleSpace, .otherItemsProxy]
        return touchBar
    }
    
    func setTouchBar() {
        windowController?.customTouchBar = makeTouchBar()
    }
}

// MARK: NSTouchBarDelegate
extension IntroState: NSTouchBarDelegate {
    var fontArrow: NSFont? { NSFont(name: "PressStart2P-Regular", size: 12) }
    var fontClose: NSFont? { NSFont(name: "PressStart2P-Regular", size: 14) }

    var button1: NSButton {
        let button = NSButton(title: "<", target: self, action: #selector(prevButton(_:)))
        button.font = fontArrow
        button.bezelColor = NSColor.hexadecimal(hex: 0x17B352)
        return button
    }
    
    var button2: NSButton {
        let button = NSButton(title: ">", target: self, action: #selector(nextButton(_:)))
        button.font = fontArrow
        button.bezelColor = NSColor.hexadecimal(hex: 0x17B352)
        return button
    }
    
    var button3: NSButton {
        let button = NSButton(title: "x", target: self, action: #selector(closeButton(_:)))
        button.font = fontClose
        button.bezelColor = NSColor.hexadecimal(hex: 0xFF5E55)
        return button
    }

    func touchBar(_ touchBar: NSTouchBar, makeItemForIdentifier identifier: NSTouchBarItem.Identifier) -> NSTouchBarItem? {
        let custom = NSCustomTouchBarItem(identifier: identifier)
        
        switch identifier {
        case .infoLabelItem:
            let label = NSTextField(labelWithString: "Pixel Game")
            label.font = NSFont(name: "PressStart2P-Regular", size: 16)
            custom.view = label
        case .button1:
            custom.view = button1
        case .button2:
            custom.view = button2
        case .button3:
            custom.view = button3
        case .button1Disable:
            let button = button1
            button.isEnabled = false
            custom.view = button
        case .button2Disable:
            let button = button2
            button.isEnabled = false
            custom.view = button
        case .button3Disable:
            let button = button3
            button.isEnabled = false
            custom.view = button
        default:
            return nil
        }

        return custom
    }

    @objc func prevButton(_ sender: NSButton) {
        if dialogContainer!.currentTextIndex > 0 {
            dialogContainer?.currentTextIndex -= 1
            dialogContainer?.label.text = dialogContainer?.textDialog[dialogContainer!.currentTextIndex]
        }
        windowController?.customTouchBar = makeTouchBar()
    }

    @objc func nextButton(_ sender: NSButton) {
        if let textDialog = dialogContainer?.textDialog,
            dialogContainer!.currentTextIndex < textDialog.count-1 {
            dialogContainer?.currentTextIndex += 1
            dialogContainer?.label.text = dialogContainer?.textDialog[dialogContainer!.currentTextIndex]
        }
        windowController?.customTouchBar = makeTouchBar()
    }

    @objc func closeButton(_ sender: NSButton) {
        showDialogContainer(false)
        windowController?.customTouchBar = nil
        scene.addChild(door)
    }
}
