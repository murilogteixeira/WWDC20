//
//  WindowController.swift
//  PixelGame
//
//  Created by Murilo Teixeira on 31/03/20.
//  Copyright © 2020 Murilo Teixeira. All rights reserved.
//

import Cocoa

class WindowController: NSWindowController {
    
    var customTouchBar: NSTouchBar? {
        didSet {
            touchBar = customTouchBar
        }
    }

    override func windowDidLoad() {
        super.windowDidLoad()
    
        // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
        touchBar?.delegate = self
    }
    
    override func makeTouchBar() -> NSTouchBar? {
        let touchBar = NSTouchBar()
        touchBar.delegate = self
        touchBar.customizationIdentifier = .touchBarIdentifier
        touchBar.defaultItemIdentifiers = [.flexibleSpace, .infoLabelItem, .flexibleSpace]
        return touchBar
    }
}

extension WindowController: NSTouchBarDelegate {
    func touchBar(_ touchBar: NSTouchBar, makeItemForIdentifier identifier: NSTouchBarItem.Identifier) -> NSTouchBarItem? {
        let custom = NSCustomTouchBarItem(identifier: identifier)

        let label = NSTextField(labelWithString: "Pixel Game")
        label.font = NSFont(name: "PressStart2P-Regular", size: 16)
        custom.view = label
        
        return custom
    }
}
