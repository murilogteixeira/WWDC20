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
    
    lazy var tapReceiver: NSButton = {
        let button = NSButton(title: " ", target: self, action: #selector(tap))
        button.isTransparent = true
        button.isEnabled = false
        
        if let view = GameViewController.shared?.touchBarView {
            button.frame = view.frame
        }

        return button
    }()
    
    @objc func tap() {
        atentionColor.invalidate()

        scene.fillColor = .green
        touchBarScene.label.text = "Toque confirmado. Carregando..."
        touchBarScene.label.fontColor = .black
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.touchBarScene.stateMachine.enter(DialogMenuState.self)
        }
    }
    
    let colors: [NSColor] = [.green, .black, .white]
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
        GameViewController.shared?.touchBarView.addSubview(tapReceiver)
        atentionColor.fire()
        touchBarScene.label.text = "Toque aqui para continuar!"
        tapReceiver.isEnabled = true
    }
    
    public override func willExit(to nextState: GKState) {
        touchBarScene.label.fontColor = .white
        touchBarScene.label.text = "Pixel Game"
        tapReceiver.isEnabled = false
    }
    
    init(touchBarScene: TouchBarScene) {
        self.touchBarScene = touchBarScene
        super.init()
    }
}
