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

class AlertState: GKState {
    unowned let touchBarScene: TouchBarScene
    lazy var scene: SKSpriteNode = self.touchBarScene.sceneTB
    
    lazy var tapReceiver: NSButton = {
        let button = NSButton(title: " ", target: self, action: #selector(tap))
        button.isTransparent = true
        
        if let view = WindowController.shared?.touchBarView {
            button.frame = view.frame
        }

        return button
    }()
    
    @objc func tap() {
        
        atentionColor.invalidate()
        finishColor.fire()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.finishColor.invalidate()
            self.touchBarScene.stateMachine.enter(DialogMenuState.self)
        }
    }
    
    let colors: [NSColor] = [.white, .black]
    var currentColor = 0
    lazy var atentionColor = Timer.scheduledTimer(withTimeInterval: 0.2, repeats: true) { _ in
        self.scene.color = self.colors[self.currentColor]
        if self.currentColor == 0 {
            self.currentColor = 1
        }
        else {
            self.currentColor = 0
        }
        self.touchBarScene.label.color = self.colors[self.currentColor]
    }
    
    lazy var finishColor = Timer.scheduledTimer(withTimeInterval: 0.075, repeats: true) { _ in
        self.scene.color = self.colors[self.currentColor]
        if self.currentColor == 0 {
            self.currentColor = 1
            self.touchBarScene.label.color = .green
        }
        else {
            self.currentColor = 0
            self.touchBarScene.label.color = .blue
        }
    }
    
    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        switch stateClass {
        case is DialogMenuState.Type:
            return true
        default:
            return false
        }
    }
    
    override func didEnter(from previousState: GKState?) {
        WindowController.shared?.touchBarView.addSubview(tapReceiver)
        atentionColor.fire()
    }
    
    override func willExit(to nextState: GKState) {
        
    }
    
    init(touchBarScene: TouchBarScene) {
        self.touchBarScene = touchBarScene
        super.init()
    }
}
