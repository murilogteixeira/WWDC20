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
        Use a iTool para mover as linhas e executar
        
        o código. Primeiro toque na linha origem e
        
          depois na linha destino para organizar.
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
            Organize o código de criação de
            
                árvores e seus frutos
            """,
            "codeLines": [
                0: "let arvore = Arvore()",
                1: "let fruta = Laranja()",
                2: "if arvore.fruta == laranja {",
                3: "  arvore.criarFruta(fruta)",
                4: "}"
            ]
        ],
        [
            "title": """
            Organize o código de criação da
            
            casa para colocar os objeto nos
            
            locais corretos
            """,
            "codeLines": [
                0: "let casa = Casa()",
                1: "let objeto = Porta()",
                2: "if casa.frente.porta != porta {",
                3: "  casa.frente.addPorta(objeto)",
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
                          codeLines: codeScreenData)
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
