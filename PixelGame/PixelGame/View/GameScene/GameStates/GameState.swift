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

public class GameState: GKState {
    unowned let gameScene: GameScene
    lazy var controlNode: SKNode = gameScene.controlNode
    lazy var scene: SKSpriteNode = buildScene()
    
    lazy var hero = gameScene.hero
    
    var collectable: Collectable {
        let collectableSize: CGFloat = 50
        let widthScene = (self.scene.size.width / 2) - (collectableSize * 3)
        let heightScene = scene.size.height / 2
        let position = CGPoint(x: CGFloat.random(in: -widthScene..<widthScene),
                               y: (self.scene.size.height / 2) + collectableSize)
        let node = Collectable(position: position)
        let moveAction: SKAction = .moveTo(y: -heightScene - 50, duration: TimeInterval.random(in: 2..<3))
        moveAction.timingMode = .easeIn
        node.run(.sequence([moveAction, .removeFromParent()]))
        return node
    }
    
    var bug: Bug {
        let collectableSize: CGFloat = 30
        let widthScene = (self.scene.size.width / 2) - (collectableSize * 3)
        let heightScene = scene.size.height / 2
        let position = CGPoint(x: CGFloat.random(in: -widthScene..<widthScene),
                               y: (self.scene.size.height / 2) + collectableSize)
        let node = Bug(position: position)
        let moveAction: SKAction = .moveTo(y: -heightScene - 50, duration: TimeInterval.random(in: 1.75..<2.5))
        moveAction.timingMode = .easeIn
        node.run(.sequence([moveAction, .removeFromParent()]))
        return node
    }

    lazy var codeBlocksCollectedLabel: SKLabelNode = {
        let label = SKLabelNode(fontNamed: kFontName)
        label.name = NodeName.blocksCountLabel.rawValue
        label.zPosition = NodesZPosition.elements.rawValue
        label.text = "\(hero.codeBlocksCount)"
        label.fontSize = 18
        label.fontColor = .black
        let positionX = (scene.size.width / 2) - (label.frame.size.width * 3)
        let positionY = (scene.size.height / 2) - (label.frame.size.height * 3)
        label.position = CGPoint(x: positionX, y: positionY)
        return label
    }()
    
    public override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        switch stateClass {
        case is BuildRoomState.Type:
            return true
        case is CreditsState.Type:
            return true
        default:
            return false
        }
    }
    
    public override func didEnter(from previousState: GKState?) {
        gameScene.physicsWorld.contactDelegate = self
        
        controlNode.addChild(scene)
        controlNode.alpha = 0
        controlNode.run(.fadeAlpha(to: 1.0, duration: 0.4))
        
        scene.addChild(hero)
        hero.position = hero.initialPosition
        
        scene.addChild(codeBlocksCollectedLabel)
        
        initCollectables()
        initBugs()
    }
    
    public override func willExit(to nextState: GKState) {
        self.scene.removeAllChildren()
        self.scene.removeFromParent()
    }
    
    //MARK: Update
    public override func update(deltaTime seconds: TimeInterval) {
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
    
    public init(gameScene: GameScene) {
        self.gameScene = gameScene
        super.init()
    }
}

extension GameState {
    func initCollectables() {
        let addCollectable: SKAction = .run {
            self.scene.addChild(self.collectable)
        }
        let waitCollectable: SKAction = .wait(forDuration: TimeInterval.random(in: 0.5..<1))
        let sequenceCollectable: SKAction = .sequence([addCollectable, waitCollectable])
        scene.run(.repeatForever(sequenceCollectable))
    }
    
    func initBugs() {
        let addBug: SKAction = .run {
            self.scene.addChild(self.bug)
        }
        let waitBug: SKAction = .wait(forDuration: TimeInterval.random(in: 1..<2))
        let sequenceBug: SKAction = .sequence([addBug, waitBug])
        scene.run(.repeatForever(sequenceBug))
    }
}

extension GameState: SKPhysicsContactDelegate {
    public func didBegin(_ contact: SKPhysicsContact) {
        
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
        else if nodeNameA == .floor || nodeNameB == .floor {
            guard let floor = (nodeNameA == .floor ? nodeA : nodeB) as? Floor else { return }
            let object = nodeNameA != .floor ? nodeA : nodeB
            
            floor.contact(scene, floor, object: object)
        }
    }
}
