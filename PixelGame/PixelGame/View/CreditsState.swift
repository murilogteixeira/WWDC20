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
    var controlNode: SKNode!
    var scene: SKSpriteNode!
    
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
        
        scene = SKSpriteNode()
        scene.size = gameScene.size
        scene.zPosition = NodesZPosition.background.rawValue
        scene.name = NodeName.background.rawValue
        
        controlNode?.addChild(scene)
        
        scene.addChild(SKNode())
    }
    
    override func willExit(to nextState: GKState) {
        self.scene.removeAllChildren()
        self.scene.removeFromParent()
        self.controlNode = nil
        self.scene = nil
    }
    
    init(gameScene: GameScene) {
        self.gameScene = gameScene
        super.init()
    }

}
