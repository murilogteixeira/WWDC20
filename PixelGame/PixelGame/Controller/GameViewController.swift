//
//  ViewController.swift
//  PixelGame
//
//  Created by Murilo Teixeira on 31/03/20.
//  Copyright © 2020 Murilo Teixeira. All rights reserved.
//

import Cocoa
import SpriteKit
import GameplayKit

class GameViewController: NSViewController, NSTouchBarDelegate {

    @IBOutlet var skView: SKView!
    var scene: GameScene!
        
    override func viewDidLoad() {
        super.viewDidLoad()

        if let view = self.skView {
            // Load GameScene
            scene = GameScene(controller: self)
            // Set the scale mode to scale to fit the window
            scene.scaleMode = .aspectFit
            // Present the scene
            scene.size = view.frame.size
            view.presentScene(scene)
        
            view.ignoresSiblingOrder = true
            view.showsFPS = true
            view.showsNodeCount = true
            view.showsPhysics = true
        }
    }
    
}
