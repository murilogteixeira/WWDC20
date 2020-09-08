//
//  AlertState.swift
//  PixelGame
//
//  Created by Murilo Teixeira on 02/04/20.
//  Copyright © 2020 Murilo Teixeira. All rights reserved.
//

import Cocoa
import SpriteKit
import GameplayKit

public class AlertState: GKState {
    unowned let touchBarScene: TouchBarScene
    lazy var scene: SKShapeNode = self.touchBarScene.sceneTB
    lazy var label = touchBarScene.label
    
    var currentString = 0
    
    let strings = [
        "Tap here to continue",
        "Confirmed identity. Loading...",
        "Action buttons will be shown when available. Tap here to continue.",
        "And visual alerts will be displayed. Tap here to continue.",
        "Tap here to show available actions"
    ]
    
    lazy var tapReceiver: NSButton = {
        let button = NSButton(title: " ", target: self, action: #selector(tap))
        button.isTransparent = true
        
        button.frame = TouchBarView.shared.frame

        return button
    }()
    
    @objc func tap() {
        atentionColor.invalidate()
        scene.fillColor = .black
        label.fontColor = .cyan
        label.position = .zero
        
        currentString += 1
        guard currentString < strings.count else {
            self.touchBarScene.stateMachine.enter(DialogMenuState.self)
            TouchBarView.manager.notify(.didBegin)
            return
        }
        
        label.text = strings[currentString]
        alignLabel()
                
        if currentString == 1 {
            label.fontColor = .green
            touchBarScene.notifyTouchBar(color: .green, duration: 0.075)
            tapReceiver.isEnabled = false
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.75) {
                self.currentString += 1
                self.tapReceiver.isEnabled = true
                
                self.label.text = self.strings[self.currentString]
                self.alignLabel()
                self.touchBarScene.notifyTouchBar(color: .cyan, duration: 0.075)
                self.label.fontColor = .cyan
            }
        }
        else {
            touchBarScene.notifyTouchBar(color: .cyan, duration: 0.075)
        }
    }
    
    func alignLabel() {
        label.position = CGPoint(x: 0, y: 0)
        label.removeAllActions()
        
        if label.frame.size.width > scene.frame.size.width - 100 {
            label.horizontalAlignmentMode = .left
            let positionX: CGFloat = label.position.x - ((scene.frame.size.width / 2) * 0.8)
            label.position = CGPoint(x: positionX, y: 0)

            let toPositionX = -label.frame.size.width + ((scene.frame.size.width / 2) * 0.8)

            let duration = TimeInterval(label.frame.size.width * 0.0025)

            let moveLeft: SKAction = .moveTo(x: toPositionX, duration: duration)
            let moveRight: SKAction = .moveTo(x: positionX, duration: duration)
            let wait: SKAction = .wait(forDuration: 0.8)
            let sequence: SKAction = .sequence([wait, moveLeft, wait, moveRight])
            label.run(.repeatForever(sequence))
        }
        else {
            label.horizontalAlignmentMode = .center
        }
    }
    
    let colors: [SKColor] = [.cyan, .black, .white]
    var currentColor = 0
    lazy var atentionColor = Timer.scheduledTimer(withTimeInterval: 0.25, repeats: true) { _ in
        self.scene.fillColor = self.colors[self.currentColor]
        if self.currentColor == 0 {
            self.currentColor = 1
        }
        else {
            self.currentColor = 0
        }
        self.touchBarScene.label.fontColor = self.colors[self.currentColor]
    }
    
    public override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        switch stateClass {
        case is DialogMenuState.Type:
            return true
        default:
            return false
        }
    }
    
    public override func didEnter(from previousState: GKState?) {
        TouchBarView.shared.addSubview(tapReceiver)
        
        atentionColor.fire()
        
        label.position = CGPoint(x: 0, y: 0)
        label.text = strings[currentString]
        alignLabel()
        
    }
    
    public override func willExit(to nextState: GKState) {
        touchBarScene.label.fontColor = .white
        touchBarScene.label.text = "Pixel Game"
        tapReceiver.removeFromSuperview()
    }
    
    init(touchBarScene: TouchBarScene) {
        self.touchBarScene = touchBarScene
        super.init()
    }
}
