//
//  IdleState.swift
//  PixelGame
//
//  Created by Murilo Teixeira on 02/04/20.
//  Copyright © 2020 Murilo Teixeira. All rights reserved.
//

import Cocoa
import SpriteKit
import GameplayKit

class IdleState: GKState {
    unowned let touchBarScene: TouchBarScene
    lazy var scene: SKSpriteNode = self.touchBarScene.sceneTB
    
    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        switch stateClass {
        case is DialogMenuState.Type:
            return true
        case is AlertState.Type:
            return true
        default:
            return false
        }
    }
    
    override func didEnter(from previousState: GKState?) {
        touchBarScene.resetLabel()
    }
    
    override func willExit(to nextState: GKState) {
        
    }
    
    init(touchBarScene: TouchBarScene) {
        self.touchBarScene = touchBarScene
        super.init()
    }
}
