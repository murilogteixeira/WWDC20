//
//  TouchBarScene.swift
//  PixelGame
//
//  Created by Murilo Teixeira on 02/04/20.
//  Copyright © 2020 Murilo Teixeira. All rights reserved.
//

import SpriteKit
import GameplayKit

protocol TouchBarSceneDelegate: AnyObject {
    func touchesBegan(with event: NSEvent)
    func touchesEnded(with event: NSEvent)
}

public class TouchBarScene: SKScene {
    static var shared: TouchBarScene?
    static var showAlert = true
    
    weak var delegateTB: TouchBarSceneDelegate?
    
    lazy var stateMachine = GKStateMachine(states: self.states)
    
    private lazy var states = [
        IdleState(touchBarScene: self),
        AlertState(touchBarScene: self),
        DialogMenuState(touchBarScene: self),
        ConfirmState(touchBarScene: self),
        OrganizeCodeLine(touchBarScene: self),
    ]

    lazy var sceneTB: SKShapeNode = {
        let node = SKShapeNode(rect: CGRect(x: -size.width / 2, y: -size.height / 2,
                                            width: size.width, height: size.height), cornerRadius: 5)
        node.strokeColor = .clear
        node.zPosition = TouchBarConstants.NodeZPosition.background.rawValue
        node.name = TouchBarConstants.Name.background.rawValue
        return node
    }()
    
    lazy var label: SKLabelNode = {
        let label = SKLabelNode()
        label.text = "Pixel Game"
        label.fontName = kFontName
        label.position = CGPoint(x: 0, y: 0)
        label.fontSize = 16
        label.fontColor = .white
        label.verticalAlignmentMode = .center
        label.horizontalAlignmentMode = .center
        return label
    }()

    // MARK: didMove
    public override func didMove(to view: SKView) {
        anchorPoint = CGPoint(x: 0.5, y: 0.5)
        addChild(sceneTB)
        backgroundColor = .black
        addChild(label)
        stateMachine.enter(IdleState.self)
    }
    
    public override func update(_ currentTime: TimeInterval) {
        stateMachine.currentState?.update(deltaTime: currentTime)
    }
    
    public override init(size: CGSize) {
        super.init(size: size)
        TouchBarScene.shared = self
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}

//MARK: TouchBarScene
extension TouchBarScene {
    func moveLabel(completion: @escaping () -> Void) {
        let move = SKAction.moveTo(x: sceneTB.frame.size.width * -0.25, duration: 1)
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
    
//    func toAlert() {
//        let colors: [SKColor] = [.white, .black]
//        var i = 0
//        let color1: SKAction = .run { [weak self] in
//            guard let scene = self else { return }
//            scene.sceneTB.fillColor = colors[i]
//            i += 1
//        }
//        let color2: SKAction = .run { [weak self] in
//            guard let scene = self else { return }
//            scene.sceneTB.fillColor = colors[i]
//            i -= 1
//        }
//        let wait: SKAction = .wait(forDuration: 0.05)
//        let sequence: [SKAction] = [color1, wait, color2, wait, color1, wait, color2]
//        sceneTB.run(.sequence(sequence))
//    }
    
    func notifyTouchBar(color: SKColor, duration: TimeInterval = 0.1) {
        let color1: SKAction = .run {
            self.sceneTB.fillColor = color
        }
        let color2: SKAction = .run {
            self.sceneTB.fillColor = .black
        }
        let wait: SKAction = .wait(forDuration: duration)
        let sequence: SKAction = .sequence([color1, wait, color2, wait, color1, wait, color2])
        run(sequence)
    }
}
