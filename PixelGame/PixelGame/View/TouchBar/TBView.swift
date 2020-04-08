//
//  TBView.swift
//  PixelGame
//
//  Created by Murilo Teixeira on 06/04/20.
//  Copyright © 2020 Murilo Teixeira. All rights reserved.
//

import SpriteKit

class TouchBarView: SKView {
    static var shared: TouchBarView!
    static var manager = TouchBarManager()
    
    var tbScene: TouchBarScene! {
        didSet {
            print("iniciou")
        }
    }
    
    public override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        TouchBarScene.shared = TouchBarScene(size: frame.size)
        presentScene(TouchBarScene.shared)
    }
        
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}

extension TouchBarView: NSTouchBarDelegate {
    
    override func makeTouchBar() -> NSTouchBar? {
        let touchBar = NSTouchBar()
        touchBar.delegate = self
        touchBar.customizationIdentifier = .touchBarIdentifier
        touchBar.defaultItemIdentifiers = [.view]
        return touchBar
    }
    
    func touchBar(_ touchBar: NSTouchBar, makeItemForIdentifier identifier: NSTouchBarItem.Identifier) -> NSTouchBarItem? {
        let custom = NSCustomTouchBarItem(identifier: identifier)
        custom.view = self
        return custom
    }
}
