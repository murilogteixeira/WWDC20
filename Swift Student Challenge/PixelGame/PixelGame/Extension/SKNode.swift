//
//  SKNode.swift
//  PixelGame
//
//  Created by Murilo Teixeira on 04/04/20.
//  Copyright © 2020 Murilo Teixeira. All rights reserved.
//

import SpriteKit

extension SKNode {
    func destroy(fadeOut: TimeInterval = 0, moveWhileDisappearing: Bool = false) {
        self.physicsBody = nil
        
        let disappear = SKAction.fadeAlpha(to: 0, duration: fadeOut)

        run(.sequence([disappear, .removeFromParent()]))
        
        if moveWhileDisappearing {
            run(.moveTo(y: position.y + 20, duration: fadeOut))
        }
    }
}
