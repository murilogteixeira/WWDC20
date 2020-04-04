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
public class GameScene: SKScene {
    
    lazy var states = [
        IntroState(gameScene: self),
        GameState(gameScene: self),
        BuildRoomState(gameScene: self),
        CreditsState(gameScene: self)
    ]
    
    lazy var stateMachine = GKStateMachine(states: self.states)
    
    lazy var controlNode: SKNode = {
        let node = SKNode()
        node.position = CGPoint.zero
        node.name = NodeName.controlNode.rawValue
        node.zPosition = NodesZPosition.controlNode.rawValue
        return node
    }()
    
    var directionPressed = KeyCode.none
    var upKey = Key(pressed: false, busy: false, name: .up)
    
    weak var delegateScene: GameSceneDelegate?
    
    lazy var floor = Floor(size: CGSize(width: frame.size.width, height: frame.height * 0.15),
                           position: CGPoint(x: 0, y: -size.height / 2))
    lazy var leftWall = Wall(height: size.height, positionX: -size.width / 2)
    lazy var rightWall = Wall(height: size.height, positionX: size.width / 2)
    
    lazy var hero: Hero = {
        let hero = Hero(size: 80)
        delegateScene = hero
        return hero
    }()
    
    public override func didMove(to view: SKView) {
        stateMachine.enter(IntroState.self)
//        stateMachine.enter(GameState.self)

        anchorPoint = CGPoint(x: 0.5, y: 0.5)
        
        addChild(controlNode)
        
        controlNode.addChild(leftWall)
        controlNode.addChild(rightWall)
        controlNode.addChild(floor)

    }
    
    // MARK: Update
    public override func update(_ currentTime: TimeInterval) {
        stateMachine.currentState?.update(deltaTime: currentTime)
    }
    
    public override init(size: CGSize) {
        super.init(size: size)
        NSEvent.addLocalMonitorForEvents(matching: .keyDown, handler: customKeyDown(event:))
        NSEvent.addLocalMonitorForEvents(matching: .keyUp, handler: customKeyUp(event:))
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}

// MARK: CustomKeyDown/Up
extension GameScene {
    func customKeyDown(event: NSEvent) -> NSEvent? {
        delegateScene?.keyDown(self, keyCode: KeyCode(rawValue: event.keyCode))
        return nil
    }
    
    func customKeyUp(event: NSEvent) -> NSEvent? {
        delegateScene?.keyUp(self, keyCode: KeyCode(rawValue: event.keyCode))
        return nil
    }
}
