//
//  TouchBar.swift
//  PixelGame
//
//  Created by Murilo Teixeira on 31/03/20.
//  Copyright © 2020 Murilo Teixeira. All rights reserved.
//

import Cocoa

extension NSTouchBarItem.Identifier {
    static let infoLabelItem = NSTouchBarItem.Identifier("com.murilo.Label")
    static let button1 = NSTouchBarItem.Identifier("com.murilo.Button1")
    static let button2 = NSTouchBarItem.Identifier("com.murilo.Button2")
    static let button3 = NSTouchBarItem.Identifier("com.murilo.Button3")
}

extension NSTouchBar.CustomizationIdentifier {
    static let touchBarIdentifier = NSTouchBar.CustomizationIdentifier("com.murilo.PixelGame.TouchBar")
}
