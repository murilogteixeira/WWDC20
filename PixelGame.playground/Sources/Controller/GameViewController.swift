//
//  GameViewController.swift
//  PixelGame
//
//  Created by Murilo Teixeira on 31/03/20.
//  Copyright © 2020 Murilo Teixeira. All rights reserved.
//

import Cocoa
import SpriteKit
import GameplayKit

public class GameViewController: NSViewController {
    public static var shared: GameViewController?

    var touchBarView = SKView(frame: CGRect(x: 0, y: 0, width: 685, height: 30))
    var touchBarManager = TouchBarManager()
    var touchBarItemsIdentifier: [NSTouchBarItem.Identifier] = [.view] {
        didSet {
            touchBar = makeTouchBar()
        }
    }
    
    func viewDidLoaded() {
        
    }
}

extension GameViewController: NSTouchBarDelegate {

    public override func makeTouchBar() -> NSTouchBar? {
        
        let touchBar = NSTouchBar()
        touchBar.delegate = self
        touchBar.customizationIdentifier = .touchBarIdentifier
        touchBar.defaultItemIdentifiers = touchBarItemsIdentifier
        return touchBar
    }

    public func touchBar(_ touchBar: NSTouchBar, makeItemForIdentifier identifier: NSTouchBarItem.Identifier) -> NSTouchBarItem? {
        let custom = NSCustomTouchBarItem(identifier: identifier)

        switch identifier {
        case .view:
            let touchBarScene = TouchBarScene(size: touchBarView.frame.size)
            TouchBarScene.shared = touchBarScene
            touchBarView.presentScene(touchBarScene)
            touchBarView.showsNodeCount = true
            custom.view = touchBarView
        default:
            return nil
        }

        return custom
    }
    
}
