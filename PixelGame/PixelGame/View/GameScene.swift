//
//  GameScene.swift
//  PixelGame
//
//  Created by Murilo Teixeira on 31/03/20.
//  Copyright © 2020 Murilo Teixeira. All rights reserved.
//

import SpriteKit
import GameplayKit

protocol GameSceneDelegate: AnyObject {
    func keyDown(_ gameScene: GameScene, keyCode: KeyCode?)
    func keyUp(_ gameScene: GameScene, keyCode: KeyCode?)
}

//MARK: GameScene
class GameScene: SKScene {
    
    lazy var states = [
        IntroState(gameScene: self),
        GameState(gameScene: self),
        BuildRoomState(gameScene: self),
        CreditsState(gameScene: self)
    ]
    
    lazy var gameState = GKStateMachine(states: self.states)
    
    weak var delegateScene: GameSceneDelegate?
    
    lazy var controlNode: SKNode = {
        let node = SKNode()
        node.position = CGPoint.zero
        node.name = NodeName.controlNode.rawValue
        node.zPosition = NodesZPosition.controlNode.rawValue
        return node
    }()
    
    override func didMove(to view: SKView) {
        gameState.enter(IntroState.self)
        
        anchorPoint = CGPoint(x: 0.5, y: 0.5)
        
        addChild(controlNode)
    }
    
    // MARK: Update
    override func update(_ currentTime: TimeInterval) {
        gameState.currentState?.update(deltaTime: currentTime)
    }
    
    func customKeyDown(event: NSEvent) -> NSEvent? {
        delegateScene?.keyDown(self, keyCode: KeyCode(rawValue: event.keyCode))
        return nil
    }
    
    func customKeyUp(event: NSEvent) -> NSEvent? {
        delegateScene?.keyUp(self, keyCode: KeyCode(rawValue: event.keyCode))
        return nil
    }
    
    override init(size: CGSize) {
        super.init(size: size)
        NSEvent.addLocalMonitorForEvents(matching: .keyDown, handler: customKeyDown(event:))
        NSEvent.addLocalMonitorForEvents(matching: .keyUp, handler: customKeyUp(event:))
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
