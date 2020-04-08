//
//  Hero.swift
//  PixelGame
//
//  Created by Murilo Teixeira on 31/03/20.
//  Copyright © 2020 Murilo Teixeira. All rights reserved.
//

import SpriteKit

// MARK: Hero
public class Hero: SKSpriteNode {
    
    var codeBlocksCount = 0
    let codeBlocksGoal = 50
    var builderWasShown = false
    
    var walking = false {
        didSet {
            guard canMove else { return }
            if !jumping {
                if walking {
                    walkAnimation(true)
                    stopAnimation(false)
                }
                else {
                    walkAnimation(false)
                    stopAnimation(true)
                }
            }
        }
    }
    
    var isWalking = false {
        didSet {
            if isOnTheFloor {
                walking = isWalking
            }
        }
    }
    
    var jumping = false {
        didSet {
            if jumping {
                texture = jumpingFrame
                walkAnimation(false)
                stopAnimation(false)
                speedMoviment = jumpingSpeed
            }
            else {
                speedMoviment = groundSpeed
            }
        }
    }
    
    //MARK: Frames
    private lazy var stoppedFrames: [SKTexture] = {
        var textures = [SKTexture]()
        for i in 0..<stoppedFramesFormat.count {
            textures.append(PixelArtObject(format: stoppedFramesFormat[i], size: self.size).objectTexture)
        }
        return textures
    }()
    
    private lazy var walkingFrames: [SKTexture] = {
        var textures = [SKTexture]()
        for i in 0..<walkingFramesFormat.count {
            textures.append(PixelArtObject(format: walkingFramesFormat[i], size: self.size).objectTexture)
        }
        return textures
    }()
    
    private lazy var jumpingFrame: SKTexture = {
        return PixelArtObject(format: jumpingFrameFormat, size: self.size).objectTexture
    }()
    
    // MARK: Inicial settings
    lazy var initialPosition: CGPoint = {
        CGPoint(x: 360 * -0.8, y: 240 * -0.5)
    }()
    
    var groundSpeed: CGFloat = 5.5
    var jumpingSpeed: CGFloat = 6.5
    lazy var speedMoviment: CGFloat = groundSpeed
    
    var isOnTheFloor = false {
        didSet {
            if isOnTheFloor {
                jumping = false
            }
        }
    }
    var canJump = true
    var canMove = true

    // MARK: Init
    convenience init(size: CGFloat) {
        self.init()
        self.size = CGSize(width: size, height: size)
        self.position = initialPosition
        self.name = NodeName.hero.rawValue
        self.zPosition = NodesZPosition.character.rawValue
        
        setupPhysicsBody()
        stopAnimation(true)
    }
    
    // MARK: SetuPhysicsBody
    func setupPhysicsBody() {
        let heroCategory = CategoryBitmask.hero.rawValue
        let floorCategory = CategoryBitmask.floor.rawValue
        let dialogBoxCategory = CategoryBitmask.dialogBox.rawValue
        let wallCategory = CategoryBitmask.wall.rawValue
        let doorCategory = CategoryBitmask.door.rawValue

        physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: self.size.width * 0.6, height: self.size.height))
        physicsBody?.categoryBitMask = heroCategory
        physicsBody?.contactTestBitMask = floorCategory | dialogBoxCategory | doorCategory
        physicsBody?.collisionBitMask = floorCategory | wallCategory
        physicsBody?.allowsRotation = false
    }
}

//MARK: Moviments
extension Hero {
    func move(direction: KeyCode) {
        guard canMove else { return }

        switch direction {
        case .left:
            run(.moveTo(x: position.x - speedMoviment, duration: 0))
            xScale = abs(xScale) * -1
        case .right:
            run(.moveTo(x: position.x + speedMoviment, duration: 0))
            xScale = abs(xScale) * 1
        default:
            break
        }
    }
    
    func jump() {
        guard canJump else { return }
        
        canJump = false
        jumping = true
        physicsBody?.applyImpulse(CGVector(dx: 0, dy: 110))
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.95) {
            self.canJump = true
        }
        
    }
}

// MARK: Animations
extension Hero {
    private func stopAnimation(_ actived: Bool) {
        guard actived else {
            removeAction(forKey: "stoppedAnimation")
            return
        }
        let animation = SKAction.animate(with: stoppedFrames, timePerFrame: 0.2)
        run(.repeatForever(animation), withKey: "stoppedAnimation")
    }
    
    private func walkAnimation(_ actived: Bool) {
        guard actived else {
            self.removeAction(forKey: "walkingAnimation")
            return
        }
        let animation = SKAction.animate(with: walkingFrames, timePerFrame: 0.075)
        run(.repeatForever(animation), withKey: "walkingAnimation")
    }
}

//MARK: GameSceneDelegate
extension Hero: GameSceneDelegate {
    func keyDown(_ gameScene: GameScene, keyCode: KeyCode?) {
        switch keyCode {
        case .left:
            if gameScene.directionPressed == .none {
                gameScene.directionPressed = .left
                isWalking = true
            }
        case .right:
            if gameScene.directionPressed == .none {
                gameScene.directionPressed = .right
                isWalking = true
            }
        case .up:
            gameScene.upKey.pressed = true
            jump()
        default:
            print("Key not configured")
        }
    }

    func keyUp(_ gameScene: GameScene, keyCode: KeyCode?) {
        switch keyCode {
        case .left:
            if gameScene.directionPressed == .left {
                gameScene.directionPressed = .none
                isWalking = false
            }
        case .right:
            if gameScene.directionPressed == .right {
                gameScene.directionPressed = .none
                isWalking = false
            }
        case .up:
            gameScene.upKey.pressed = false
        default:
            break
        }
    }
}

//MARK: ContactPhysics
extension Hero {
    func contact(_ sceneParent: SKSpriteNode, _ heroNode: Hero, object: SKNode) {
        
        let objectName = NodeName(rawValue: object.name!)!
        
        switch objectName {
        case .floor:
            isOnTheFloor = true
            if isOnTheFloor {
                walking = isWalking
            }
        case .dialogBox:
            guard let dialogContainer = (object as? DialogBox)?.dialogContainer else { return }
            dialogContainer.show(in: sceneParent)
            object.destroy(fadeOut: 0.5)
            (object as? SKSpriteNode)?.flash(with: .hexadecimal(0xFFB500))
            
            sceneParent.removeAllActions()
            
            sceneParent.children.forEach { node in
                if node.name != nil, let nodeName = NodeName(rawValue: node.name!),
                    nodeName != .hero, nodeName != .messageBox, nodeName != .dialogBox {
                    node.removeFromParent()
                }
            }
            
        case .collectable:
            codeBlocksCount += 1
            
            object.removeAllActions()
            object.destroy(fadeOut: 0.5, moveWhileDisappearing: true)
            (object as? SKSpriteNode)?.flash(with: .green)
            
            changeCountLabel(scene: sceneParent)
            showBuildBox(scene: sceneParent)
        case .bug:
            
            codeBlocksCount = 0
            
            TouchBarScene.shared?.notifyTouchBar(color: .red)
            flash(with: .red, count: 10, colorBlendFactor: 0.3)
            
            object.removeAllActions()
            object.destroy(fadeOut: 0.3)
            
            changeCountLabel(scene: sceneParent)
            
            if GameScene.shared.stateMachine.currentState is GameState,
                let dialogBox = sceneParent.childNode(withName: NodeName.dialogBox.rawValue) {
                
                dialogBox.removeAllActions()
                dialogBox.run(.moveTo(y: (sceneParent.frame.size.height / 2) + dialogBox.frame.size.height, duration: 0))
                builderWasShown = false
            }
        case .door:
            if let door = object as? Door {
                door.canOpen = true
            }
        default:
            break
        }
    }
    
    func changeCountLabel(scene: SKNode) {
        guard let childNode = scene.childNode(withName: NodeName.blocksCountLabel.rawValue),
            let label = childNode as? SKLabelNode else { return }
        label.text = "\(codeBlocksCount)"
    }
    
    func showBuildBox(scene: SKNode) {
        if !builderWasShown, codeBlocksCount >= 1, let buildBox = scene.childNode(withName: NodeName.dialogBox.rawValue) {
            builderWasShown = true

            let moveAction: SKAction = .moveTo(y: 0, duration: 2)
            moveAction.timingMode = .easeInEaseOut
            buildBox.run(moveAction)
        }
    }
}

// MARK: Format
extension Hero {
    var c: SKColor { .clear } // transparente
    var b: SKColor {.hexadecimal(0x362E22)} // cabelo, maos, pes
    var n: SKColor {.hexadecimal(0xFFE6A0)} // pele
    var o: SKColor {.hexadecimal(0xD9AE35)} // oculos
    var r: SKColor {.hexadecimal(0xEF860C)} // camisa
    var y: SKColor {.hexadecimal(0xF7F534)} // cinto
    var l: SKColor {.hexadecimal(0x1168F2)} // calça e manga da blusa
    
    var stoppedFramesFormat: [[[SKColor]]] {
       [[ // 1
            [c,c,b,b,b,b,b,b,c],
            [c,b,b,b,b,b,b,b,b],
            [b,b,b,n,n,n,n,b,b],
            [b,b,n,n,n,n,n,n,b],
            [b,n,o,o,o,o,o,o,o],
            [n,n,o,n,b,o,b,n,o],
            [n,n,o,n,b,o,b,n,o],
            [c,n,o,o,o,o,o,o,o],
            [c,c,n,n,n,n,n,n,c],
            [c,c,l,r,r,r,r,c,c],
            [c,c,l,r,y,y,r,c,c],
            [c,c,b,l,y,y,l,c,c],
            [c,c,l,l,l,l,l,c,c],
            [c,c,c,l,c,l,c,c,c],
            [c,c,c,b,c,b,c,c,c],
        ],[ // 2
            [c,c,c,c,c,c,c,c,c],
            [c,c,b,b,b,b,b,b,c],
            [c,b,b,b,b,b,b,b,b],
            [b,b,b,n,n,n,n,b,b],
            [b,b,n,n,n,n,n,n,b],
            [b,n,o,o,o,o,o,o,o],
            [n,n,o,n,b,o,b,n,o],
            [n,n,o,n,b,o,b,n,o],
            [c,n,o,o,o,o,o,o,o],
            [c,c,n,n,n,n,n,n,c],
            [c,c,l,r,r,r,r,c,c],
            [c,c,l,r,y,y,r,c,c],
            [c,c,b,l,y,y,l,c,c],
            [c,c,l,l,l,l,l,c,c],
            [c,c,c,b,c,b,c,c,c],
        ],[ // 3
            [c,c,c,c,c,c,c,c,c],
            [c,c,c,c,c,c,c,c,c],
            [c,c,b,b,b,b,b,b,c],
            [c,b,b,b,b,b,b,b,b],
            [b,b,b,n,n,n,n,b,b],
            [b,b,n,n,n,n,n,n,b],
            [b,n,o,o,o,o,o,o,o],
            [n,n,o,n,b,o,b,n,o],
            [n,n,o,n,b,o,b,n,o],
            [c,n,o,o,o,o,o,o,o],
            [c,c,l,r,r,r,r,c,c],
            [c,c,l,r,y,y,r,c,c],
            [c,c,b,l,y,y,l,c,c],
            [c,c,l,l,l,l,l,c,c],
            [c,c,c,b,c,b,c,c,c],
        ],[ // 4
            [c,c,c,c,c,c,c,c,c],
            [c,c,b,b,b,b,b,b,c],
            [c,b,b,b,b,b,b,b,b],
            [b,b,b,n,n,n,n,b,b],
            [b,b,n,n,n,n,n,n,b],
            [b,n,o,o,o,o,o,o,o],
            [n,n,o,n,b,o,b,n,o],
            [n,n,o,n,b,o,b,n,o],
            [c,n,o,o,o,o,o,o,o],
            [c,c,l,r,r,r,r,c,c],
            [c,c,l,r,y,y,r,c,c],
            [c,c,b,l,y,y,l,c,c],
            [c,c,l,l,l,l,l,c,c],
            [c,c,c,l,c,l,c,c,c],
            [c,c,c,b,c,b,c,c,c],
        ]]
    }
    
    
    var walkingFramesFormat: [[[SKColor]]] {
        [[ // 1
            [c,c,c,c,c,c,c,c,c],
            [c,c,b,b,b,b,b,b,c],
            [c,b,b,b,b,b,b,b,b],
            [b,b,b,n,n,n,n,b,b],
            [b,b,n,n,n,n,n,n,b],
            [b,n,o,o,o,o,o,o,o],
            [n,n,o,n,b,o,b,n,o],
            [n,n,o,n,b,o,b,n,o],
            [c,n,o,o,o,o,o,o,o],
            [c,c,n,n,n,n,n,n,c],
            [c,c,l,r,r,r,r,c,c],
            [c,l,r,r,y,y,r,c,c],
            [c,b,l,l,y,y,l,b,c],
            [c,c,l,l,l,l,l,c,c],
            [c,c,c,c,b,c,c,c,c],
        ],[ // 2
            [c,c,c,c,c,c,c,c,c],
            [c,c,c,c,c,c,c,c,c],
            [c,c,b,b,b,b,b,b,c],
            [c,b,b,b,b,b,b,b,b],
            [b,b,b,n,n,n,n,b,b],
            [b,b,n,n,n,n,n,n,b],
            [b,n,o,o,o,o,o,o,o],
            [n,n,o,n,b,o,b,n,o],
            [n,n,o,n,b,o,b,n,o],
            [c,n,o,o,o,o,o,o,o],
            [c,c,l,r,r,r,r,c,c],
            [c,l,r,r,y,y,r,l,c],
            [b,c,l,l,y,y,l,c,b],
            [c,c,l,l,l,l,l,c,c],
            [c,c,c,b,c,c,b,c,c],
        ],[ // 3
            [c,c,c,c,c,c,c,c,c],
            [c,c,b,b,b,b,b,b,c],
            [c,b,b,b,b,b,b,b,b],
            [b,b,b,n,n,n,n,b,b],
            [b,b,n,n,n,n,n,n,b],
            [b,n,o,o,o,o,o,o,o],
            [n,n,o,n,b,o,b,n,o],
            [n,n,o,n,b,o,b,n,o],
            [c,n,o,o,o,o,o,o,o],
            [c,c,l,r,r,r,r,c,c],
            [c,l,r,r,y,y,r,c,c],
            [c,b,l,l,y,y,l,b,c],
            [c,c,l,l,l,l,l,c,c],
            [c,c,c,l,c,c,l,c,c],
            [c,c,b,c,c,c,b,c,c],
        ],[ // 4
            [c,c,b,b,b,b,b,b,c],
            [c,b,b,b,b,b,b,b,b],
            [b,b,b,n,n,n,n,b,b],
            [b,b,n,n,n,n,n,n,b],
            [b,n,o,o,o,o,o,o,o],
            [n,n,o,n,b,o,b,n,o],
            [n,n,o,n,b,o,b,n,o],
            [c,n,o,o,o,o,o,o,o],
            [c,c,n,n,n,n,n,n,c],
            [c,c,l,r,r,r,r,c,c],
            [c,c,l,r,y,y,r,c,c],
            [c,c,b,l,y,y,l,c,c],
            [c,c,l,l,l,l,l,c,c],
            [c,c,c,l,c,l,c,c,c],
            [c,c,c,b,c,b,c,c,c],
        ],[ // 5
            [c,c,c,c,c,c,c,c,c],
            [c,c,b,b,b,b,b,b,c],
            [c,b,b,b,b,b,b,b,b],
            [b,b,b,n,n,n,n,b,b],
            [b,b,n,n,n,n,n,n,b],
            [b,n,o,o,o,o,o,o,o],
            [n,n,o,n,b,o,b,n,o],
            [n,n,o,n,b,o,b,n,o],
            [c,n,o,o,o,o,o,o,o],
            [c,c,n,n,n,n,n,n,c],
            [c,c,l,r,r,r,r,c,c],
            [c,c,r,l,y,y,r,c,c],
            [c,c,l,b,y,y,l,c,c],
            [c,c,l,l,l,l,l,c,c],
            [c,c,c,c,b,c,c,c,c],
        ],[ // 6
            [c,c,c,c,c,c,c,c,c],
            [c,c,c,c,c,c,c,c,c],
            [c,c,b,b,b,b,b,b,c],
            [c,b,b,b,b,b,b,b,b],
            [b,b,b,n,n,n,n,b,b],
            [b,b,n,n,n,n,n,n,b],
            [b,n,o,o,o,o,o,o,o],
            [n,n,o,n,b,o,b,n,o],
            [n,n,o,n,b,o,b,n,o],
            [c,n,o,o,o,o,o,o,o],
            [c,c,l,r,r,r,r,c,c],
            [c,c,r,l,y,y,r,c,c],
            [c,c,l,l,b,y,l,c,c],
            [c,c,l,l,l,l,l,c,c],
            [c,c,c,b,c,c,b,c,c],
        ],[ // 7
            [c,c,c,c,c,c,c,c,c],
            [c,c,b,b,b,b,b,b,c],
            [c,b,b,b,b,b,b,b,b],
            [b,b,b,n,n,n,n,b,b],
            [b,b,n,n,n,n,n,n,b],
            [b,n,o,o,o,o,o,o,o],
            [n,n,o,n,b,o,b,n,o],
            [n,n,o,n,b,o,b,n,o],
            [c,n,o,o,o,o,o,o,o],
            [c,c,l,r,r,r,r,c,c],
            [c,c,r,l,y,y,r,c,c],
            [c,c,l,b,y,y,l,c,c],
            [c,c,l,l,l,l,l,c,c],
            [c,c,c,l,c,c,l,c,c],
            [c,c,b,c,c,c,b,c,c],
        ],[ // 8
            [c,c,b,b,b,b,b,b,c],
            [c,b,b,b,b,b,b,b,b],
            [b,b,b,n,n,n,n,b,b],
            [b,b,n,n,n,n,n,n,b],
            [b,n,o,o,o,o,o,o,o],
            [n,n,o,n,b,o,b,n,o],
            [n,n,o,n,b,o,b,n,o],
            [c,n,o,o,o,o,o,o,o],
            [c,c,n,n,n,n,n,n,c],
            [c,c,l,r,r,r,r,c,c],
            [c,c,l,r,y,y,r,c,c],
            [c,c,b,l,y,y,l,c,c],
            [c,c,l,l,l,l,l,c,c],
            [c,c,c,l,c,l,c,c,c],
            [c,c,c,b,c,b,c,c,c],
        ]]
    }
    
    var jumpingFrameFormat: [[SKColor]] {
        [ // 1
            [c,c,b,b,b,b,b,b,c],
            [c,b,b,b,b,b,b,b,b],
            [b,b,b,n,n,n,n,b,b],
            [b,b,n,n,n,n,n,n,b],
            [b,n,o,o,o,o,o,o,o],
            [n,n,o,n,b,o,b,n,o],
            [n,n,o,n,b,o,b,n,o],
            [c,n,o,o,o,o,o,o,o],
            [c,c,n,n,n,n,n,n,c],
            [c,l,l,r,r,r,r,l,c],
            [c,b,r,r,y,y,r,b,c],
            [c,c,l,l,y,y,l,c,c],
            [c,c,l,l,l,l,l,c,c],
            [c,c,b,c,b,c,c,c,c],
            [c,c,c,c,c,c,c,c,c],
        ]
    }
}
