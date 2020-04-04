//
//  CollectableIntroState.swift
//  PixelGame
//
//  Created by Murilo Teixeira on 31/03/20.
//  Copyright © 2020 Murilo Teixeira. All rights reserved.
//

import Cocoa
import SpriteKit
import GameplayKit

class GameState: GKState {
    unowned let gameScene: GameScene
    lazy var controlNode: SKNode = gameScene.controlNode
    lazy var scene: SKSpriteNode = buildScene()
    
    lazy var hero = gameScene.hero
    
    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        switch stateClass {
        case is BuildRoomState.Type:
            return true
        case is CreditsState.Type:
            return true
        default:
            return false
        }
    }
    
    override func didEnter(from previousState: GKState?) {
        controlNode.addChild(scene)
        controlNode.alpha = 0
        controlNode.run(.fadeAlpha(to: 1.0, duration: 0.4))
        
        scene.addChild(hero)
        hero.position = hero.initialPosition
    }
    
    override func willExit(to nextState: GKState) {
        self.scene.removeAllChildren()
        self.scene.removeFromParent()
    }
    
    //MARK: Update
    public override func update(deltaTime seconds: TimeInterval) {
        hero.move(direction: gameScene.directionPressed)
    }
    
    func buildScene() -> SKSpriteNode {
        let node = SKSpriteNode()
        node.color = .hexadecimal(hex: 0xC9FFFD)
        node.size = gameScene.size
        node.zPosition = NodesZPosition.background.rawValue
        node.name = NodeName.background.rawValue
        return node
    }
    
    init(gameScene: GameScene) {
        self.gameScene = gameScene
        super.init()
    }
}
