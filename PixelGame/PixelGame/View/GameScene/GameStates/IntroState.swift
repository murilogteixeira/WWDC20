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
        let node = DialogMessageContainer(position: .zero, size: 500, textDialog: textDialog)
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
        let node = DialogMessageContainer(position: .zero, size: 400, textDialog: textDialog)
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
        let node = DialogMessageContainer(position: .zero, size: 400, textDialog: textDialog)
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
        let position = CGPoint(x: (scene.size.width / 2) - (size.width / 2), y: -150)
        let node = Door(size: size, position: position)
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
        node.color = .hexadecimal(0xC9FFFD)
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
    }
}

extension IntroState {
    func showDoor() {
        scene.addChild(door)
        door.isShow = true
    }
    
    func hiddeDoor() {
        door.removeFromParent()
        door.isShow = false
    }
}

//MARK: TouchBarSubscriberNotifyer
extension IntroState: TouchBarSubscriber {
    func didEnded() {
        currentAction += 1
        if currentAction < sceneActions.count {
            runAction(action: sceneActions[currentAction], inNode: scene)
        }
        else if !door.isShow {
            showDoor()
        }
    }
    
    func confirmButtonPressed() {
        gameScene.stateMachine.enter(GameState.self)
    }
    
    public override var description: String { "IntroState" }
}

//MARK: SKPhysicsContactDelegate
extension IntroState: SKPhysicsContactDelegate {
    public func didBegin(_ contact: SKPhysicsContact) {
        let heroName = NodeName.hero.rawValue
        let floorName = NodeName.floor.rawValue
        let dialogBoxName = NodeName.dialogBox.rawValue
        let doorName = NodeName.door.rawValue
        
        if let nodeA = contact.bodyA.node, let nodeB = contact.bodyB.node,
            nodeA.name == heroName && nodeB.name == floorName ||
                nodeA.name == floorName && nodeB.name == heroName {
            
            hero.isOnTheFloor = true
        }
        else if let nodeA = contact.bodyA.node, let nodeB = contact.bodyB.node,
            nodeA.name == dialogBoxName || nodeB.name == dialogBoxName {
            
            let dialogBoxNode = (nodeA.name == dialogBoxName ? nodeA : nodeB) as! DialogBox
            let object = nodeA.name != dialogBoxName ? nodeA : nodeB
            
            dialogBoxNode.contact(scene, dialogBoxNode, with: object)
        }
        else if let nodeA = contact.bodyA.node, let nodeB = contact.bodyB.node,
            nodeA.name == doorName && nodeB.name == heroName ||
                nodeA.name == heroName && nodeB.name == doorName {
            
            door.canOpen = true
        }
    }
    
    public func didEnd(_ contact: SKPhysicsContact) {
        let heroName = NodeName.hero.rawValue
        let doorName = NodeName.door.rawValue
        
        if let nodeA = contact.bodyA.node, let nodeB = contact.bodyB.node,
            nodeA.name == doorName && nodeB.name == heroName ||
                nodeA.name == heroName && nodeB.name == doorName {
            
            door.canOpen = false
        }
    }
}
