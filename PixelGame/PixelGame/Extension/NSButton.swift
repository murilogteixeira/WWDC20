//
//  NSButton.swift
//  PixelGame
//
//  Created by Murilo Teixeira on 07/04/20.
//  Copyright © 2020 Murilo Teixeira. All rights reserved.
//

import Cocoa
import SpriteKit

extension NSButton {
    func flash(with color: SKColor, count: Int = 3) -> Timer? {
        guard let bezelColor = bezelColor else { return nil }
        
        let toColor: SKColor = color
        let discolor: SKColor = bezelColor

        self.bezelColor = color
        
        var index = 1
        let timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { timer in
            if index == 0 {
                self.bezelColor = toColor
                index = 1
            }
            else {
                self.bezelColor = discolor
                index = 0
            }
        }
        
        return timer
    }
}
