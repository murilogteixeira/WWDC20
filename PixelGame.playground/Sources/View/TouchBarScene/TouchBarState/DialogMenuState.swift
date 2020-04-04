//
//  DialogMenuState.swift
//  PixelGame
//
//  Created by Murilo Teixeira on 02/04/20.
//  Copyright © 2020 Murilo Teixeira. All rights reserved.
//

import Cocoa
import SpriteKit
import GameplayKit

public class DialogMenuState: GKState {
    unowned let touchBarScene: TouchBarScene
    lazy var scene: SKShapeNode = touchBarScene.sceneTB
    
    lazy var prevButton: NSButton = {
        let button = NSButton(title: "<", target: self, action: #selector(prevButtonAction))
        button.frame = CGRect(x: 360, y: 0, width: 70, height: 30)
        button.font = NSFont(name: kFontName, size: 12)
        button.bezelColor = .hexadecimal(hex: 0x17B352)
        return button
    }()
    
    @objc func prevButtonAction() {
        GameViewController.shared?.touchBarManager.prevButton()
    }
    
    lazy var nextButton: NSButton = {
        let button = NSButton(title: ">", target: self, action: #selector(nextButtonAction))
        button.frame = CGRect(x: 440, y: 0, width: 70, height: 30)
        button.font = NSFont(name: kFontName, size: 12)
        button.bezelColor = .hexadecimal(hex: 0x17B352)
        return button
    }()
    
    @objc func nextButtonAction() {
        GameViewController.shared?.touchBarManager.nextButton()
    }
    
    lazy var closeButton: NSButton = {
        let button = NSButton(title: "x", target: self, action: #selector(closeButtonAction))
        button.frame = CGRect(x: 520, y: 0, width: 70, height: 30)
        button.font = NSFont(name: kFontName, size: 14)
        button.bezelColor = .hexadecimal(hex: 0xFF5E55)
        return button
    }()
    
    @objc func closeButtonAction() {
        GameViewController.shared?.touchBarManager.closeButton()
        touchBarScene.stateMachine.enter(IdleState.self)
    }
    
    lazy var buttonsContainerFrame = CGRect(x: scene.frame.size.width * 0.2, y: 0, width: scene.frame.size.width * 0.35, height: scene.frame.size.height)
    lazy var buttonsContainer: NSView = {
        let view = NSView(frame: buttonsContainerFrame)
        return view
    }()
    
    public override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        switch stateClass {
        case is IdleState.Type:
            return true
        default:
            return false
        }
    }
    
    public override func didEnter(from previousState: GKState?) {
        scene.fillColor = .black
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

extension DialogMenuState {
    func showButtons() {
        touchBarScene.moveLabel { [weak self] in
            guard let state = self else { return }
            GameViewController.shared?.touchBarView.addSubview(state.prevButton)
            GameViewController.shared?.touchBarView.addSubview(state.nextButton)
            GameViewController.shared?.touchBarView.addSubview(state.closeButton)
        }
        GameViewController.shared?.touchBarManager.didBegin()
    }
    
    func hiddeButtons() {
        prevButton.removeFromSuperview()
        nextButton.removeFromSuperview()
        closeButton.removeFromSuperview()
        touchBarScene.resetLabel()
        GameViewController.shared?.touchBarManager.didEnded()
    }
    
}
