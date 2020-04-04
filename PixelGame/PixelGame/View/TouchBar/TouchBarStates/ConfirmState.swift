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
    
    lazy var button: NSButton = {
        let button = NSButton(title: "Entrar", target: self, action: #selector(tap))
        button.frame = CGRect(x: 440, y: 0, width: 100, height: 30)
        button.font = NSFont(name: kFontName, size: 12)
        button.bezelColor = .hexadecimal(hex: 0x17B352)
        return button
    }()
    
    @objc func tap() {
        touchBarScene.stateMachine.enter(IdleState.self)
        GameViewController.shared?.touchBarManager.confirmButton()
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
        showButtons()
    }
    
    public override func willExit(to nextState: GKState) {
        hiddeButtons()
    }
    
    init(touchBarScene: TouchBarScene) {
        self.touchBarScene = touchBarScene
        super.init()
    }
}

extension ConfirmState {
    func showButtons() {
        touchBarScene.toAlert()
        touchBarScene.moveLabel { [weak self] in
            guard let state = self else { return }
            GameViewController.shared?.touchBarView.addSubview(state.button)
        }
        GameViewController.shared?.touchBarManager.didBegin()
    }
    
    func hiddeButtons() {
        button.removeFromSuperview()
        touchBarScene.resetLabel()
        GameViewController.shared?.touchBarManager.didEnded()
    }
    
}
