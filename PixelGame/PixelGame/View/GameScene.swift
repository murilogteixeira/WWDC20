//
//  GameScene.swift
//  PixelGame
//
//  Created by Murilo Teixeira on 31/03/20.
//  Copyright © 2020 Murilo Teixeira. All rights reserved.
//

import SpriteKit
import GameplayKit

enum NotificationType {
    case keyDown, keyUp
}

protocol GameSceneSubscriber: CustomStringConvertible {
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
    
    lazy var controlNode: SKNode = {
        let node = SKNode()
        node.position = CGPoint.zero
        node.name = NodeName.controlNode.rawValue
        node.zPosition = NodesZPosition.controlNode.rawValue
        return node
    }()
    
    var directionPressed = KeyCode.none
    var upKey = Key(pressed: false, busy: false, name: .up)
    
    private lazy var subscribers = [GameSceneSubscriber]()
    
    override func didMove(to view: SKView) {
        gameState.enter(IntroState.self)
        
        anchorPoint = CGPoint(x: 0.5, y: 0.5)
        
        addChild(controlNode)
    }
    
    // MARK: Update
    override func update(_ currentTime: TimeInterval) {
        gameState.currentState?.update(deltaTime: currentTime)
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

extension GameScene {
    func customKeyDown(event: NSEvent) -> NSEvent? {
        notifySubscribers(.keyDown, keyCode: KeyCode(rawValue: event.keyCode))
        return nil
    }
    
    func customKeyUp(event: NSEvent) -> NSEvent? {
        notifySubscribers(.keyUp, keyCode: KeyCode(rawValue: event.keyCode))
        return nil
    }
}

extension GameScene {
    func add(subscriber: GameSceneSubscriber) {
        print("GameScene: Subscriber added: \(subscriber.description)")
        subscribers.append(subscriber)
    }
    
    func remove(subscriber filter: (GameSceneSubscriber) -> (Bool)) {
        guard let index = subscribers.firstIndex(where: filter) else { return }
        subscribers.remove(at: index)
    }
    
    private func notifySubscribers(_ type: NotificationType?, keyCode: KeyCode?) {
        switch type {
        case .keyDown:
            subscribers.forEach({ $0.keyDown(self, keyCode: keyCode)})
        case .keyUp:
            subscribers.forEach({ $0.keyUp(self, keyCode: keyCode)})
        default:
            break
        }
    }
}
