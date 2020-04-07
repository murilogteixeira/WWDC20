//
//  OrganizeCodeLine.swift
//  PixelGame
//
//  Created by Murilo Teixeira on 06/04/20.
//  Copyright © 2020 Murilo Teixeira. All rights reserved.
//

import Cocoa
import SpriteKit
import GameplayKit

public class OrganizeCodeLine: GKState {
    unowned let touchBarScene: TouchBarScene
    lazy var scene: SKShapeNode = touchBarScene.sceneTB
    
    var buttonOrder: [Int]!
    
    let initialPositionX: CGFloat = 100
    lazy var currentPositionX = initialPositionX
    
    let buttonSize = CGSize(width: 70, height: 30)
    
    lazy var buttons: [NSButton] = [button1, button2, button3, button4, button5, ]

    //MARK:button1
    private lazy var button1: NSButton = {
        let button = NSButton(title: "1", target: self, action: #selector(tapButton1))
        button.font = NSFont(name: kFontName, size: 12)
        button.bezelColor = .hexadecimal(0x0763CE)
        return button
    }()

    @objc private func tapButton1(sender: NSButton) {
        TouchBarView.manager.notify(.numberButton, with: sender)
    }

    //MARK:button2
    private lazy var button2: NSButton = {
        let button = NSButton(title: "2", target: self, action: #selector(tapButton2))
        button.font = NSFont(name: kFontName, size: 12)
        button.bezelColor = .hexadecimal(0x0763CE)
        return button
    }()

    @objc private func tapButton2(sender: NSButton) {
        TouchBarView.manager.notify(.numberButton, with: sender)
    }

    //MARK:button3
    private lazy var button3: NSButton = {
        let button = NSButton(title: "3", target: self, action: #selector(tapButton3))
        button.font = NSFont(name: kFontName, size: 12)
        button.bezelColor = .hexadecimal(0x0763CE)
        return button
    }()

    @objc private func tapButton3(sender: NSButton) {
        TouchBarView.manager.notify(.numberButton, with: sender)
    }

    //MARK:button4
    private lazy var button4: NSButton = {
        let button = NSButton(title: "4", target: self, action: #selector(tapButton4))
        button.font = NSFont(name: kFontName, size: 12)
        button.bezelColor = .hexadecimal(0x0763CE)
        return button
    }()

    @objc private func tapButton4(sender: NSButton) {
        TouchBarView.manager.notify(.numberButton, with: sender)
    }

    //MARK:button5
    private lazy var button5: NSButton = {
        let button = NSButton(title: "5", target: self, action: #selector(tapButton5))
        button.font = NSFont(name: kFontName, size: 12)
        button.bezelColor = .hexadecimal(0x0763CE)
        return button
    }()

    @objc private func tapButton5(sender: NSButton) {
        TouchBarView.manager.notify(.numberButton, with: sender)
    }

    //MARK:button6
    private lazy var button6: NSButton = {
        let button = NSButton(title: "▶︎", target: self, action: #selector(tapButton6))
        button.font = NSFont(name: kFontName, size: 12)
        button.bezelColor = .hexadecimal(0x15CE5A)
        return button
    }()

    @objc private func tapButton6(sender: NSButton) {
        TouchBarView.manager.notify(.playButton, with: sender)
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
        currentPositionX = initialPositionX
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

extension OrganizeCodeLine {
    func showButtons() {
        
        touchBarScene.notifyTouchBar(color: .white, duration: 0.075)
        
        touchBarScene.moveLabel { [weak self] in
            guard let state = self, let buildRoomState = GameScene.shared.stateMachine.currentState as? BuildRoomState else { return }

            state.buttonOrder = buildRoomState.codeScreen.labelOrder
                
            
            for i in 0..<state.buttons.count {
                let index = state.buttonOrder[i]
                state.buttons[index].frame = CGRect(x: state.currentPositionX, y: 0, width: state.buttonSize.width, height: state.buttonSize.height)
                TouchBarView.shared.addSubview(state.buttons[state.buttonOrder[i]])
                state.currentPositionX += 75
            }
            
            state.currentPositionX += 30
            state.button6.frame = CGRect(x: state.currentPositionX, y: 0, width: state.buttonSize.width, height: state.buttonSize.height)
            TouchBarView.shared.addSubview(state.button6)
        }
        TouchBarView.manager.notify(.didBegin)
    }

    func hiddeButtons() {
        button1.removeFromSuperview()
        button2.removeFromSuperview()
        button3.removeFromSuperview()
        button4.removeFromSuperview()
        button5.removeFromSuperview()
        touchBarScene.resetLabel()
        TouchBarView.manager.notify(.didEnded)
    }

}
