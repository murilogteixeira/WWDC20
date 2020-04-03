//
//  WindowController.swift
//  PixelGame
//
//  Created by Murilo Teixeira on 31/03/20.
//  Copyright © 2020 Murilo Teixeira. All rights reserved.
//

import Cocoa
import SpriteKit

class WindowController: NSWindowController {
    static var shared: WindowController?
    
    var touchBarView = SKView(frame: NSRect(x: 0, y: 0, width: 685, height: 30))
    var touchBarManager = TouchBarManager()
    var touchBarItemsIdentifier: [NSTouchBarItem.Identifier] = [.view] {
        didSet {
            touchBar = makeTouchBar()
        }
    }

    @objc func teste() {
        print("teste")
    }

    override func windowDidLoad() {
        super.windowDidLoad()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        WindowController.shared = self
    }
}

extension WindowController: NSTouchBarDelegate {
    
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
