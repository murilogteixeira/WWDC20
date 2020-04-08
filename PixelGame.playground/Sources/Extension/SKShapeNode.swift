//
//  SKShapeNode.swift
//  PixelGame
//
//  Created by Murilo Teixeira on 07/04/20.
//  Copyright © 2020 Murilo Teixeira. All rights reserved.
//

import SpriteKit

extension SKShapeNode {
    func flash(fillColor color: SKColor, count: Int = 3) {
        let prevColor = fillColor
        let toColor: SKAction = .run {
            self.fillColor = color
        }
        let discolor: SKAction = .run {
            self.fillColor = prevColor
        }
        let wait: SKAction = .wait(forDuration: 0.05)
        let sequence: SKAction = .sequence([toColor, wait, discolor, wait])
        
        if count == 0 {
            run(.repeat(sequence, count: count))
        }
        else {
            run(.repeat(sequence, count: count))
        }
    }
    
    func flash(strokeColor color: SKColor, count: Int = 3) {
        let prevColor = strokeColor
        let prevLineWidth = lineWidth
        let toColor: SKAction = .run {
            self.strokeColor = color
            self.lineWidth = 4
        }
        let discolor: SKAction = .run {
            self.strokeColor = prevColor
            self.lineWidth = prevLineWidth
        }
        let wait: SKAction = .wait(forDuration: 0.1)
        let sequence: SKAction = .sequence([toColor, wait, discolor, wait])
        
        if count == 0 {
            run(.repeatForever(sequence))
        }
        else {
            run(.repeat(sequence, count: count))
        }
    }
}
