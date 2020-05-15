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

public class BuildRoomState: GKState {
    unowned let gameScene: GameScene
    lazy var controlNode: SKNode = gameScene.controlNode
    lazy var scene: SKSpriteNode = buildScene()
    
    lazy var hero = gameScene.hero
    
    lazy var intructionLabel: SKLabelNode = {
        let label = SKLabelNode(fontNamed: kFontName)
        label.text = """
        Use iTool to move the lines and run the code.
        
        First touch the source line and then the
        
        destination line to organize.
        """
        label.position = CGPoint(x: 0, y: (scene.frame.size.height / 2) * -0.65)
        label.fontColor = .black
        label.fontSize = 9
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        label.verticalAlignmentMode = .center
        label.horizontalAlignmentMode = .center
        label.zPosition = NodesZPosition.label.rawValue
        return label
    }()
    
    lazy var titleLabel: SKLabelNode = {
        let label = SKLabelNode(fontNamed: kFontName)
        label.text = self.codeScreenData[self.currentData]["title"] as? String
        label.position = CGPoint(x: 0, y: (scene.frame.size.height / 2) * 0.6)
        label.fontColor = .black
        label.fontSize = 10
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        label.verticalAlignmentMode = .center
        label.horizontalAlignmentMode = .center
        label.zPosition = NodesZPosition.label.rawValue
        return label
    }()
    
    var currentData = 0
    let codeScreenData = [
        [
            "title": """
            Organize the code to create trees
            
            and their fruits
            """,
            "codeLines": [
                0: "let tree = Tree()",
                1: "let fruit = Orange()",
                2: "if tree.fruit == 'orange' {",
                3: "  tree.createFruit(fruit)",
                4: "}"
            ]
        ],
        [
            "title": """
            Organize the house creation code to
            
            place objects in the correct places.
            """,
            "codeLines": [
                0: "let house = House()",
                1: "let object = Door()",
                2: "if house.front.door != door {",
                3: "  house.front.addDoor(object)",
                4: "}",
            ]
        ],
    ]
    
    lazy var codeScreen: CodeScreen = {
//        guard let codeLines = codeScreenData[currentData]["codeLines"] as? [Int : String] else { return CodeScreen() }
        let heightProportion: CGFloat = 0.475
        let widthProportion: CGFloat = 0.6
        return CodeScreen(position: CGPoint(x: 0, y: 0),
                          size: CGSize(width: scene.size.width * widthProportion, height: scene.size.height * heightProportion),
                          codeLines: codeScreenData, name: "codeScreen")
    }()
    
    public override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        switch stateClass {
        case is GameState.Type:
            return true
        default:
            return false
        }
    }
    
    public override func didEnter(from previousState: GKState?) {
        gameScene.physicsWorld.contactDelegate = self
        hero.canJump = false
        hero.canMove = false

        controlNode.addChild(scene)
        controlNode.alpha = 0
        controlNode.run(.fadeAlpha(to: 1.0, duration: 0.4))
        
        hero.position = hero.initialPosition
        scene.addChild(hero)
        
        scene.addChild(titleLabel)
        scene.addChild(intructionLabel)
        codeScreen.update()
        scene.addChild(codeScreen)
        
        TouchBarScene.shared?.stateMachine.enter(OrganizeCodeLine.self)
        TouchBarView.manager.add(subscriber: codeScreen)
    }
    
    public override func willExit(to nextState: GKState) {
        self.scene.removeAllChildren()
        self.scene.removeFromParent()
        hero.canJump = true
        hero.canMove = true
        
        TouchBarView.manager.remove(subscriber: codeScreen)
    }
    
    public override func update(deltaTime seconds: TimeInterval) {
        
    }
    
    func buildScene() -> SKSpriteNode {
        let node = SKSpriteNode()
        node.color = .hexadecimal(0xE6FFFE)
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
    }
}
