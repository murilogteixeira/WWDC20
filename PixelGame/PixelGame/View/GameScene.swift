//
//  GameScene.swift
//  PixelGame
//
//  Created by Murilo Teixeira on 31/03/20.
//  Copyright © 2020 Murilo Teixeira. All rights reserved.
//

import SpriteKit
import GameplayKit

//MARK: GameScene
class GameScene: SKScene {

    lazy var windowController: WindowController? = {
        if let mainWindow = NSApplication.shared.mainWindow,
            let windowController = mainWindow.windowController as? WindowController {
            return windowController
        }
        return nil
    }()
    
    var directionPressed = KeyName.none
    var upKey = Key(pressed: false, busy: false, name: .up)
    
    var heroWalking = false {
        didSet {
            if hero.isOnTheFloor {
                hero.walking = heroWalking
            }
        }
    }
    
    var hero = Hero(size: 80)
    var floor = Floor()
    var leftWall = Wall()
    var rightWall = Wall()
    var dialogBox: DialogBox!
    
    var timeSinceLastContactWithFloor: TimeInterval = 0
    
    var controller: GameViewController!
    
    convenience init(controller: GameViewController) {
        self.init()
        self.controller = controller
        
        
    }
    
    override func didMove(to view: SKView) {
        physicsWorld.contactDelegate = self
        backgroundColor = .white
        anchorPoint = CGPoint(x: 0.5, y: 0.5)
        
        leftWall.position.x = -360
        rightWall.position.x = 360
        
        addChild(hero)
        addChild(floor)
        addChild(leftWall)
        addChild(rightWall)
        
        let textDialog = [
            "Aqui aparecerão as dicas e \ndesafios a serem cumpridos \n\nAs ações podem ser\ncontroladas pelos botões\nna TouchBar.",
            "Caso o seu dispositivo não\npossua TouchBar basta\npressionar cmd+shift+8."]
        dialogBox = DialogBox(position: CGPoint(x: 0, y: -30), size: 30, textDialog: textDialog)
        addChild(dialogBox)
    }
    
    // MARK: Update
    override func update(_ currentTime: TimeInterval) {
        move()
        jump()
    }
    
    override func makeTouchBar() -> NSTouchBar? {
        let touchBar = NSTouchBar()
        touchBar.delegate = self
        touchBar.customizationIdentifier = .touchBarIdentifier
        touchBar.defaultItemIdentifiers = [.flexibleSpace, .infoLabelItem, .flexibleSpace, .button1, .button2, .button3, .flexibleSpace, .otherItemsProxy]
        return touchBar
    }
    
    func setTouchBar() {
        windowController?.customTouchBar = makeTouchBar()
    }
}

// MARK: Extensions:



// MARK: Move/Jump
extension GameScene {
    private func move() {
        switch directionPressed {
        case .left:
            hero.move(direction: .left)
        case .right:
            hero.move(direction: .right)
        default:
            break
        }
    }
    
    private func jump() {
        if upKey.pressed && !upKey.busy {
            upKey.busy = true
            hero.jump()
            hero.isOnTheFloor = false
        }
    }
}

// MARK: KeyDown/Up
extension GameScene {
    override func keyDown(with event: NSEvent) {
        let keyDown: KeyName? = KeyName(rawValue: event.keyCode)
        switch keyDown {
        case .left:
            if directionPressed == .none {
                directionPressed = .left
                heroWalking = true
            }
        case .right:
            if directionPressed == .none {
                directionPressed = .right
                heroWalking = true
            }
        case .up:
            upKey.pressed = true
        case .enter:
            dialogBox.showDialog(false)
            controller.touchBar = nil
        default:
            print("keyDown: \(event.characters!) keyCode: \(event.keyCode)")
        }
    }
    
    override func keyUp(with event: NSEvent) {
        let keyUp: KeyName? = KeyName(rawValue: event.keyCode)
        switch keyUp {
        case .left:
            if directionPressed == .left {
                directionPressed = .none
                heroWalking = false
            }
        case .right:
            if directionPressed == .right {
                directionPressed = .none
                heroWalking = false
            }
        case .up:
            upKey.pressed = false
        case .enter:
            print("EnterUp")
        default:
            print("keyUp: \(event.characters!) keyCode: \(event.keyCode)")
        }
    }
}

// MARK: Touch
extension GameScene {
    func touchDown(atPoint pos : CGPoint) {
        print("touchDown: \(pos)")
    }
    
    func touchMoved(toPoint pos : CGPoint) {
        print("touchMoved: \(pos)")
    }
    
    func touchUp(atPoint pos : CGPoint) {
        print("touchUp: \(pos)")
    }
    
    override func mouseDown(with event: NSEvent) {
        self.touchDown(atPoint: event.location(in: self))
    }
    
    override func mouseDragged(with event: NSEvent) {
        self.touchMoved(toPoint: event.location(in: self))
    }
    
    override func mouseUp(with event: NSEvent) {
        self.touchUp(atPoint: event.location(in: self))
    }
}

// MARK: SKPhysicsContactDelegate
extension GameScene: SKPhysicsContactDelegate {
    func didBegin(_ contact: SKPhysicsContact) {
        let heroCategory = CategoryBitmask.hero.rawValue
        let floorCategory = CategoryBitmask.floor.rawValue
        let dialogBoxCategory = CategoryBitmask.dialogBox.rawValue
        // Contact Hero with Floor
        if ((contact.bodyA.categoryBitMask == heroCategory) && (contact.bodyB.categoryBitMask == floorCategory)) || ((contact.bodyA.categoryBitMask == floorCategory) && (contact.bodyB.categoryBitMask == heroCategory)) {

            if hero.isOnTheFloor == false {
                hero.walking = heroWalking
            }
            hero.isOnTheFloor = true
            upKey.busy = false
        }
        else if ((contact.bodyA.categoryBitMask == heroCategory) && (contact.bodyB.categoryBitMask == dialogBoxCategory)) {
            dialogBox.contact()
            dialogBox.showDialog()
            windowController?.customTouchBar = makeTouchBar()
        }
    }
}

extension GameScene: NSTouchBarDelegate {
    fileprivate var button1Name: String { "Previous" }
    fileprivate var button2Name: String { "Next" }
    fileprivate var button3Name: String { "Close" }

    func touchBar(_ touchBar: NSTouchBar, makeItemForIdentifier identifier: NSTouchBarItem.Identifier) -> NSTouchBarItem? {
        let custom = NSCustomTouchBarItem(identifier: identifier)
        
        switch identifier {
        case .infoLabelItem:
            let label = NSTextField(labelWithString: "Pixel Game")
            label.font = NSFont(name: "PressStart2P-Regular", size: 16)
            custom.view = label
        case .button1:
            let button = NSButton(title: "<", target: self, action: #selector(prevButton(_:)))
            button.font = NSFont(name: "PressStart2P-Regular", size: 12)
            button.bezelColor = NSColor.hexadecimal(hex: 0x17B352)
            custom.view = button
        case .button2:
            let button = NSButton(title: ">", target: self, action: #selector(nextButton(_:)))
            button.font = NSFont(name: "PressStart2P-Regular", size: 12)
            button.bezelColor = NSColor.hexadecimal(hex: 0x17B352)
            custom.view = button
        case .button3:
            let button = NSButton(title: "x", target: self, action: #selector(closeButton(_:)))
            button.font = NSFont(name: "PressStart2P-Regular", size: 14)
            button.bezelColor = NSColor.hexadecimal(hex: 0xFF5E55)
            custom.view = button
        default:
            return nil
        }
        
        return custom
    }

    @objc func prevButton(_ sender: NSButton) {
        if dialogBox.currentTextIndex > 0 {
            dialogBox.currentTextIndex -= 1
            dialogBox.label?.text = dialogBox.textDialog?[dialogBox.currentTextIndex]
        }
    }

    @objc func nextButton(_ sender: NSButton) {
        if let textDialog = dialogBox.textDialog,
            dialogBox.currentTextIndex < textDialog.count-1 {
            dialogBox.currentTextIndex += 1
            dialogBox.label?.text = dialogBox.textDialog?[dialogBox.currentTextIndex]
        }
    }

    @objc func closeButton(_ sender: NSButton) {
        dialogBox.showDialog(false)
        windowController?.customTouchBar = nil
    }
}


