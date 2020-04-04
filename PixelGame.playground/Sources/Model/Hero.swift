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
    var walking = false {
        didSet {
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
    
    let velocity: CGFloat = 5
    var isOnTheFloor = false {
        didSet {
            if isOnTheFloor {
                walking = isWalking
                jumping = false
            }
        }
    }
    var canJump = true
    
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
//        NSLog("Hero Move")
        switch direction {
        case .left:
            run(.moveTo(x: position.x - velocity, duration: 0))
            xScale = abs(xScale) * -1
        case .right:
            run(.moveTo(x: position.x + velocity, duration: 0))
            xScale = abs(xScale) * 1
        default:
            break
        }
    }
    
    func jump() {
        if canJump {
            canJump = false
            jumping = true
            physicsBody?.applyImpulse(CGVector(dx: 0, dy: 110))
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.95) {
                self.canJump = true
            }
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
    public func keyDown(_ gameScene: GameScene, keyCode: KeyCode?) {
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

    public func keyUp(_ gameScene: GameScene, keyCode: KeyCode?) {
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

// MARK: Format
extension Hero {
    var c: NSColor { .clear } // transparente
    var b: NSColor {.black} // cabelo, maos, pes
    var n: NSColor {.hexadecimal(hex: 0xf6e5b5)} // pele
    var o: NSColor {.hexadecimal(hex: 0xb2a684)} // oculos
    var r: NSColor {.hexadecimal(hex: 0xc74545)} // camisa
    var y: NSColor {.hexadecimal(hex: 0xc7c55a)} // cinto
    var l: NSColor {.hexadecimal(hex: 0x25597a)} // calça e manga da blusa
    
    var stoppedFramesFormat: [[[NSColor]]] {
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
    
    
    var walkingFramesFormat: [[[NSColor]]] {
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
    
    var jumpingFrameFormat: [[NSColor]] {
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
