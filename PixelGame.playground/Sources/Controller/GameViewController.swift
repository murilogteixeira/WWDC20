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

public class GameViewController: NSViewController {
        
    @IBOutlet var skView: SKView!
    var scene: GameScene!
        
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        TouchBarView.shared = TouchBarView(frame: CGRect(x: 0, y: 0, width: 685, height: 30))

        if let view = self.skView {
            // Load GameScene
            scene = GameScene(size: view.frame.size)
            // Set the scale mode to scale to fit the window
            scene.scaleMode = .aspectFit
            view.presentScene(scene)
        
            view.ignoresSiblingOrder = true
            view.showsFPS = true
            view.showsNodeCount = true
//            view.showsPhysics = true
        }
        
    }
}

extension GameViewController {
    public override func makeTouchBar() -> NSTouchBar? {
        return TouchBarView.shared.makeTouchBar()
    }
}
