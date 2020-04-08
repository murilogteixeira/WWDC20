//
//  TouchBarIntroState.swift
//  PixelGame
//
//  Created by Murilo Teixeira on 31/03/20.
//  Copyright © 2020 Murilo Teixeira. All rights reserved.
//

import SpriteKit
import GameplayKit

public class IntroState: GKState {
    unowned let gameScene: GameScene
    lazy var controlNode: SKNode = gameScene.controlNode
    lazy var scene: SKSpriteNode = buildScene()
    private var _subscriberName: String!
    
    lazy var hero = gameScene.hero
    
    //MARK: Boxes
    var dialogBox: DialogBox {
        let boxSize: CGFloat = 30
        let widthScene = (self.scene.size.width / 2) - (boxSize * 3)
        let position = CGPoint(x: CGFloat.random(in: -widthScene..<widthScene),
                               y: (self.scene.size.height / 2) + boxSize)
        let node = DialogBox(self.scene, position: position, size: boxSize)
        let moveAction: SKAction = .moveTo(y: 0, duration: 2)
        moveAction.timingMode = .easeOut
        node.run(moveAction)
        return node
    }
    
    //MARK: Dialogs
    lazy var touchBarIntroDialog: DialogMessageContainer = {
        let textDialog = [
            """
            Olá Bug Fixer! Bem vindo ao

            Code Planet!

            
            Verifique sua iTool (TouchBar),

            e conclua as instruções para con-

            tinuar.


            Caso não a encontre, pressione

            Command+Shift+8 para exibí-la.
            """,
        ]
        let node = DialogMessageContainer(position: .zero, size: 500, textDialog: textDialog, name: "touchBarIntroDialog")
        return node
    }()
    
    lazy var collectableIntroDialog: DialogMessageContainer = {
        let textDialog = [
            """
            Este é um mundo onde tudo é

            programação. Porém, os recém

            chegados Bugs bagunçaram o
            
            código de criação do nosso

            planeta.


            Press > to next

            1/3
            """,
            """
            Os bugs coletam os blocos de

            código que compõem nossos

            objetos para usar em seus pla-

            nos malvados.


            Press > to next

            2/3
            """,
            """
            E você foi o escolhido para

            nos ajudar a corrigir os bugs

            que esses invasores causaram.


            Press x to close

            3/3
            """,
        ]
        let node = DialogMessageContainer(position: .zero, size: 400, textDialog: textDialog, name: "collectableIntroDialog")
        return node
    }()
    
    lazy var gameIntroDialog: DialogMessageContainer = {
        let textDialog = [
            """
            Na próxima parte você vai

            entrar em ação.


            Está preparado?

            Espero que sim.


            Press > to next

            1/3
            """,
            """
            Colete o máximo possível de

            blocos de código que os bugs

            deixaram escapar.


            Com eles será possível corri-

            gir os problemas que estamos

            enfrentando.


            Press > to next

            2/3
            """,
            """
            Não deixe que os bugs o atinja!

            Caso aconteça não será possivel

            pará-los e o nosso lar será to-

            talmente destruído.


            Bom trabalho!


            Press x to close

            3/3
            """,
        ]
        let node = DialogMessageContainer(position: .zero, size: 400, textDialog: textDialog, name: "gameIntroDialog")
        return node
    }()
    
    // MARK: Actions
    var currentAction = 0
    lazy var sceneActions: [SKAction] = {
        return [
            .run { [weak self] in
                guard let state = self else { return }
                let dialogBox = state.dialogBox
                dialogBox.dialogContainer = state.touchBarIntroDialog
                self?.scene.addChild(dialogBox)
            },
            .run { [weak self] in
                guard let state = self else { return }
                let dialogBox = state.dialogBox
                dialogBox.dialogContainer = state.collectableIntroDialog
                self?.scene.addChild(dialogBox)
            },
            .run { [weak self] in
                guard let state = self else { return }
                let dialogBox = state.dialogBox
                dialogBox.dialogContainer = state.gameIntroDialog
                self?.scene.addChild(dialogBox)
            },
        ]
    }()
    
    lazy var door: Door = {
        let size = CGSize(width: 60, height: 100)
        let position = CGPoint(x: (scene.size.width / 2) - (size.width), y: -155)
        let node = Door(size: 100, position: position)
        return node
    }()
    
    //MARK: IsValidNextState
    public override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        switch stateClass {
        case is GameState.Type:
            return true
        default:
            return false
        }
    }
    
    //MARK: DidEnter
    public override func didEnter(from previousState: GKState?) {
        gameScene.physicsWorld.contactDelegate = self
        
        controlNode.addChild(scene)
        controlNode.alpha = 0
        controlNode.run(.fadeAlpha(to: 1.0, duration: 0.4))
                
        scene.addChild(hero)
        
                
        runAction(action: sceneActions[currentAction], inNode: scene)
//        showDoor()
        TouchBarView.manager.add(subscriber: self)
    }
    
    //MARK: WillExit
    public override func willExit(to nextState: GKState) {
        self.scene.removeAllChildren()
        self.scene.removeFromParent()
        
        TouchBarView.manager.remove(subscriber: self)
    }
    
    //MARK: Update
    public override func update(deltaTime seconds: TimeInterval) {
        hero.move(direction: gameScene.directionPressed)
    }
    
    func buildScene() -> SKSpriteNode {
        let node = SKSpriteNode()
        node.color = .hexadecimal(0xE6FFFE)
        node.size = gameScene.size
        node.zPosition = NodesZPosition.background.rawValue
        node.name = NodeName.background.rawValue
        return node
    }
    
    func runAction(action: SKAction, inNode: SKNode) {
        inNode.run(action)
    }
    
    init(gameScene: GameScene) {
        self.gameScene = gameScene
        super.init()
        self._subscriberName = "IntroState"
    }
}

extension IntroState {
    func showDoor() {
        
        guard door.parent == nil else { return }
        door.alpha = 0
        scene.addChild(door)
        door.run(.fadeAlpha(to: 1, duration: 0.5))
        door.isShow = true
    }
    
    func hiddeDoor() {
        
        guard door.parent != nil else { return }
        door.removeFromParent()
        door.isShow = false
    }
}

//MARK: TouchBarSubscriberNotifyer
extension IntroState: TouchBarSubscriber {
    public var subscriberName: String {
        get {
            self._subscriberName
        }
        set {
            self._subscriberName = newValue
        }
    }
    
    
    public func buttonTapped(_ notificationType: TouchBarNotificationType, with button: NSButton? = nil) {
        switch notificationType {
        case .didEnded:
            currentAction += 1
            if currentAction < sceneActions.count {
                runAction(action: sceneActions[currentAction], inNode: scene)
            }
            else if !door.isShow {
                showDoor()
            }
        case .confirmButton:
            gameScene.stateMachine.enter(GameState.self)
        default:
            break
        }
    }
    
    public override var description: String { "IntroState" }
}

//MARK: SKPhysicsContactDelegate
extension IntroState: SKPhysicsContactDelegate {
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
    
    public func didEnd(_ contact: SKPhysicsContact) {
        
        guard let nodeA = contact.bodyA.node, let nodeB = contact.bodyB.node,
            let nodeAStringName = nodeA.name, let nodeBStringName = nodeB.name,
            let nodeNameA = NodeName(rawValue: nodeAStringName), let nodeNameB = NodeName(rawValue: nodeBStringName) else {
                print("GameState: Contact node has no name: \(contact)")
            return
        }
        
        if nodeNameA == .door || nodeNameB == .door {
            guard let door = (nodeNameA == .door ? nodeA : nodeB) as? Door,
            let _ = nodeNameA != .door ? nodeA : nodeB as? Hero else { return }
            
            door.canOpen = false
        }
    }
}
