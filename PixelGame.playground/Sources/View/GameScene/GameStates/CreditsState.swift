//
//  CreditsState.swift
//  PixelGame
//
//  Created by Murilo Teixeira on 31/03/20.
//  Copyright © 2020 Murilo Teixeira. All rights reserved.
//

import Cocoa
import SpriteKit
import GameplayKit

class CreditsState: GKState {
    unowned let gameScene: GameScene
    lazy var controlNode: SKNode = gameScene.controlNode
    lazy var scene: SKSpriteNode = buildScene()
    
    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        switch stateClass {
        case is GameState.Type:
            return true
        default:
            return false
        }
    }
    
    override func didEnter(from previousState: GKState?) {
        controlNode.addChild(scene)
        
        scene.addChild(SKNode())
    }
    
    override func willExit(to nextState: GKState) {
        self.scene.removeAllChildren()
        self.scene.removeFromParent()
    }
    
    override func update(deltaTime seconds: TimeInterval) {
        
    }
    
    func buildScene() -> SKSpriteNode {
        let node = SKSpriteNode()
        node.color = .hexadecimal(0xC9FFFD)
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
