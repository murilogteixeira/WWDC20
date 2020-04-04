//
//  ConfirmState.swift
//  PixelGame
//
//  Created by Murilo Teixeira on 03/04/20.
//  Copyright © 2020 Murilo Teixeira. All rights reserved.
//

import Cocoa
import GameplayKit
import SpriteKit

public class ConfirmState: GKState {
    unowned let touchBarScene: TouchBarScene
    lazy var scene: SKShapeNode = self.touchBarScene.sceneTB
    
    lazy var button: NSButton = NSButton(title: "Confirmar", target: self, action: #selector(tap))
    
    @objc func tap() {
        print("tap")
    }
    
    public override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        switch stateClass {
        case is IdleState.Type:
            return true
        default:
            return false
        }
    }
    
    public override func didEnter(from previousState: GKState?) {
        GameViewController.shared?.touchBarView.addSubview(button)
    }
    
    public override func willExit(to nextState: GKState) {
        button.removeFromSuperview()
    }
    
    init(touchBarScene: TouchBarScene) {
        self.touchBarScene = touchBarScene
        super.init()
    }
}
