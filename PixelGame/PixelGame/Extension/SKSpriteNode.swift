//
//  SKSpriteNode.swift
//  PixelGame
//
//  Created by Murilo Teixeira on 05/04/20.
//  Copyright © 2020 Murilo Teixeira. All rights reserved.
//

import SpriteKit

extension SKSpriteNode {
    func flash(with color: SKColor, count: Int = 3, colorBlendFactor: CGFloat = 1) {
        let toColor: SKAction = .colorize(with: color, colorBlendFactor: colorBlendFactor, duration: 0)
        let discolor: SKAction = .colorize(withColorBlendFactor: 0, duration: 0)
        let wait: SKAction = .wait(forDuration: 0.05)
        let sequence: SKAction = .sequence([toColor, wait, discolor, wait])
        
        run(.repeat(sequence, count: count))
    }
}
