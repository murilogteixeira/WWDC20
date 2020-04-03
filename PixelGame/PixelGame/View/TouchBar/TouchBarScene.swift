//
//  TouchBarScene.swift
//  PixelGame
//
//  Created by Murilo Teixeira on 02/04/20.
//  Copyright © 2020 Murilo Teixeira. All rights reserved.
//

import SpriteKit
import GameplayKit

//{
//    var timer: Timer?
//    var green = true
//
//    lazy var node = SKSpriteNode(color: .green, size: self.frame.size)
//
//    override func didMove(to view: SKView) {
//        timer = Timer.scheduledTimer(timeInterval: 0.3, target: self, selector: #selector(onFiresTime), userInfo: nil, repeats: true)
//    }
//
//    @objc func onFiresTime() {
//        if green {
//            green = !green
//            backgroundColor = .green
//        }
//        else {
//            green = !green
//            backgroundColor = .red
//        }
//    }
//}

protocol TouchBarSceneDelegate: AnyObject {
    func touchesBegan(with event: NSEvent)
    func touchesEnded(with event: NSEvent)
}

class TouchBarScene: SKScene {
    static var shared: TouchBarScene!
    static var showAlert = true
    
    weak var delegateTB: TouchBarSceneDelegate?
    
    lazy var stateMachine = GKStateMachine(states: self.states)
    
    private lazy var states = [
        IdleState(touchBarScene: self),
        AlertState(touchBarScene: self),
        DialogMenuState(touchBarScene: self),
    ]

    lazy var sceneTB: SKSpriteNode = {
        let node = SKSpriteNode()
        node.size = self.size
        node.position = CGPoint.zero
        node.zPosition = TouchBarConstants.NodeZPosition.background.rawValue
        node.name = TouchBarConstants.Name.background.rawValue
        return node
    }()
    
    lazy var label: SKLabelNode = {
        let label = SKLabelNode()
        label.text = "Pixel Game"
        label.fontName = kFontName
        label.fontSize = 16
        label.color = .white
        label.verticalAlignmentMode = .center
        label.horizontalAlignmentMode = .center
        return label
    }()

    // MARK: didMove
    override func didMove(to view: SKView) {
        anchorPoint = CGPoint(x: 0.5, y: 0.5)
        addChild(sceneTB)
        backgroundColor = .black
        addChild(label)
        stateMachine.enter(IdleState.self)
    }
    
    override func update(_ currentTime: TimeInterval) {
        stateMachine.currentState?.update(deltaTime: currentTime)
    }
    
    override init(size: CGSize) {
        super.init(size: size)
        TouchBarScene.shared = self
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}

//MARK: TouchBarScene
extension TouchBarScene {
    func moveLabel(completion: @escaping () -> Void) {
        let move = SKAction.moveTo(x: sceneTB.size.width * -0.25, duration: 1)
        move.timingMode = .easeInEaseOut
        
        let finish: SKAction = .run(completion)
        let sequence: SKAction = .sequence([move, finish])
        label.run(sequence)
    }
    
    func resetLabel() {
        let move = SKAction.moveTo(x: 0, duration: 1)
        move.timingMode = .easeInEaseOut
        label.run(move)
    }
}
