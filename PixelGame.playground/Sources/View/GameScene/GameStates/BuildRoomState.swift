//
//  EnemyIntroState.swift
//  PixelGame
//
//  Created by Murilo Teixeira on 31/03/20.
//  Copyright © 2020 Murilo Teixeira. All rights reserved.
//

import Cocoa
import SpriteKit
import GameplayKit

class BuildRoomState: GKState {
    unowned let gameScene: GameScene
    lazy var controlNode: SKNode = gameScene.controlNode
    lazy var scene: SKSpriteNode = buildScene()
    
    lazy var hero = gameScene.hero
    
    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        switch stateClass {
        case is GameState.Type:
            return true
        default:
            return false
        }
    }
    
    override func didEnter(from previousState: GKState?) {
        gameScene.physicsWorld.contactDelegate = self
        
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
    
    override func update(deltaTime seconds: TimeInterval) {
        hero.move(direction: gameScene.directionPressed)
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

extension BuildRoomState: SKPhysicsContactDelegate {
    func didBegin(_ contact: SKPhysicsContact) {
        guard let nodeA = contact.bodyA.node, let nodeB = contact.bodyB.node,
            let nodeAStringName = nodeA.name, let nodeBStringName = nodeB.name,
            let nodeNameA = NodeName(rawValue: nodeAStringName), let nodeNameB = NodeName(rawValue: nodeBStringName) else {
                print("GameState: Contact node has no name: \(contact)")
            return
        }
        
        if nodeNameA == .hero || nodeNameB == .hero {
            guard let hero = (nodeNameA == .hero ? nodeA : nodeB) as? Hero else { return }
            let object = (nodeNameA != .hero ? nodeA : nodeB)

            hero.contact(scene, hero, object: object)
        }
    }
}
