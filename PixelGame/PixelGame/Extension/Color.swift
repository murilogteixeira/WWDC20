//
//  Color.swift
//  PixelGame
//
//  Created by Murilo Teixeira on 31/03/20.
//  Copyright © 2020 Murilo Teixeira. All rights reserved.
//

import SpriteKit

extension SKColor {
    class func hexadecimal(_ hex: Int, alpha: CGFloat = 1) -> SKColor {
        let R = CGFloat((hex >> 16) & 0xff) / 255
        let G = CGFloat((hex >> 08) & 0xff) / 255
        let B = CGFloat((hex >> 00) & 0xff) / 255
        return SKColor(calibratedRed: R, green: G, blue: B, alpha: alpha)
    }
}
