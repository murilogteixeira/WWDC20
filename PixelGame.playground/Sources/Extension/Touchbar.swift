//
//  TouchBar.swift
//  PixelGame
//
//  Created by Murilo Teixeira on 31/03/20.
//  Copyright © 2020 Murilo Teixeira. All rights reserved.
//

import Cocoa

extension NSTouchBarItem.Identifier {
    static let view = NSTouchBarItem.Identifier("com.murilo.View")
    static let buttons = NSTouchBarItem.Identifier("com.murilo.Buttons")
    static let infoLabelItem = NSTouchBarItem.Identifier("com.murilo.Label")
    static let button1 = NSTouchBarItem.Identifier("com.murilo.Button1")
    static let button2 = NSTouchBarItem.Identifier("com.murilo.Button2")
    static let button3 = NSTouchBarItem.Identifier("com.murilo.Button3")
    static let button1Disable = NSTouchBarItem.Identifier("com.murilo.Button1Disable")
    static let button2Disable = NSTouchBarItem.Identifier("com.murilo.Button2Disable")
    static let button3Disable = NSTouchBarItem.Identifier("com.murilo.Button3Disable")
}

extension NSTouchBar.CustomizationIdentifier {
    static let touchBarIdentifier = NSTouchBar.CustomizationIdentifier("com.murilo.PixelGame.TouchBar")
}
