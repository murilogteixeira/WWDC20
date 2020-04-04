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

class GameViewController: NSViewController {
    static var shared: GameViewController?
    
    var touchBarView = SKView(frame: CGRect(x: 0, y: 0, width: 685, height: 30))
    var touchBarManager = TouchBarManager()
    var touchBarItemsIdentifier: [NSTouchBarItem.Identifier] = [.view] {
        didSet {
            touchBar = makeTouchBar()
        }
    }
    
    @IBOutlet var skView: SKView!
    var scene: GameScene!
        
    override func viewDidLoad() {
        super.viewDidLoad()

        if let view = self.skView {
            // Load GameScene
            scene = GameScene(size: view.frame.size)
            // Set the scale mode to scale to fit the window
            scene.scaleMode = .aspectFit
            view.presentScene(scene)
        
            view.ignoresSiblingOrder = true
            view.showsFPS = true
            view.showsNodeCount = true
            view.showsPhysics = true
        }
        
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        GameViewController.shared = self
    }
}

extension GameViewController: NSTouchBarDelegate {
    
    override func makeTouchBar() -> NSTouchBar? {
        let touchBar = NSTouchBar()
        touchBar.delegate = self
        touchBar.customizationIdentifier = .touchBarIdentifier
        touchBar.defaultItemIdentifiers = touchBarItemsIdentifier
        return touchBar
    }
    
    func touchBar(_ touchBar: NSTouchBar, makeItemForIdentifier identifier: NSTouchBarItem.Identifier) -> NSTouchBarItem? {
        let custom = NSCustomTouchBarItem(identifier: identifier)
        
        switch identifier {
        case .view:
            touchBarView.presentScene(TouchBarScene(size: touchBarView.frame.size))
            touchBarView.showsNodeCount = true
            custom.view = touchBarView
        default:
            return nil
        }
        
        return custom
    }
}
