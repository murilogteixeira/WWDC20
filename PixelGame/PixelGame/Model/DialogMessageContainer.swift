//
//  DialogMessageContainer.swift
//  PixelGame
//
//  Created by Murilo Teixeira on 01/04/20.
//  Copyright © 2020 Murilo Teixeira. All rights reserved.
//

import Cocoa
import SpriteKit

class DialogMessageContainer: SKSpriteNode {
    var textDialog = [String]()
    var currentTextIndex = 0
    
    var label: SKLabelNode = {
        let label = SKLabelNode()
        label.fontName = "PressStart2P-Regular"
        label.fontSize = 12
        label.fontColor = .white
        label.verticalAlignmentMode = .center
        label.horizontalAlignmentMode = .center
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        label.zPosition = NodesZPosition.label.rawValue
        label.name = NodeName.label.rawValue
        return label
    }()
    
    var dialogIsShow = false {
        didSet {
        }
    }
    
    convenience init(position: CGPoint, size: CGFloat, textDialog: [String]) {
        self.init()
        self.textDialog = textDialog
        self.size = CGSize(width: size, height: size)
        self.position = position
        
        addChild(PixelArtObject(format: format, size: self.size).objectSpriteNode)
        setScale(0)
        name = NodeName.messageBox.rawValue
        zPosition = NodesZPosition.messageBox.rawValue
        
        label.text = textDialog[currentTextIndex]
        self.addChild(label)
    }
}

extension DialogMessageContainer {
    var format: [[NSColor]] {
        [
            [c,c,c,c,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,c,c,c,c],
            [c,c,b,b,d,d,d,d,d,d,d,d,d,d,d,d,d,d,d,d,d,d,d,d,d,d,d,d,d,d,d,d,d,d,d,d,d,d,d,d,d,d,d,d,b,b,c,c],
            [c,b,d,d,l,l,l,l,l,l,l,l,l,l,l,l,l,l,l,l,l,l,l,l,l,l,l,l,l,l,l,l,l,l,l,l,l,l,l,l,l,l,l,l,d,d,b,c],
            [c,b,d,l,d,d,d,d,d,d,d,d,d,d,d,d,d,d,d,d,d,d,d,d,d,d,d,d,d,d,d,d,d,d,d,d,d,d,d,d,d,d,d,d,l,d,b,c],
            [b,d,l,d,d,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,d,d,l,d,b],
            [b,d,l,d,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,d,l,d,b],
            [b,d,l,d,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,d,l,d,b],
            [b,d,l,d,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,d,l,d,b],
            [b,d,l,d,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,d,l,d,b],
            [b,d,l,d,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,d,l,d,b],
            [b,d,l,d,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,d,l,d,b],
            [b,d,l,d,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,d,l,d,b],
            [b,d,l,d,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,d,l,d,b],
            [b,d,l,d,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,d,l,d,b],
            [b,d,l,d,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,d,l,d,b],
            [b,d,l,d,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,d,l,d,b],
            [b,d,l,d,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,d,l,d,b],
            [b,d,l,d,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,d,l,d,b],
            [b,d,l,d,d,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,d,d,l,d,b],
            [c,b,d,l,d,d,d,d,d,d,d,d,d,d,d,d,d,d,d,d,d,d,d,d,d,d,d,d,d,d,d,d,d,d,d,d,d,d,d,d,d,d,d,d,l,d,b,c],
            [c,b,d,d,l,l,l,l,l,l,l,l,l,l,l,l,l,l,l,l,l,l,l,l,l,l,l,l,l,l,l,l,l,l,l,l,l,l,l,l,l,l,l,l,d,d,b,c],
            [c,c,b,b,d,d,d,d,d,d,d,d,d,d,d,d,d,d,d,d,d,d,d,d,d,d,d,d,d,d,d,d,d,d,d,d,d,d,d,d,d,d,d,d,b,b,c,c],
            [c,c,c,c,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,c,c,c,c],
        ]
    }
    
    func showVisualFormat() {
        var formatString = String()
        for _ in 0..<format.count {
            for _ in 0..<format.first!.count {
                formatString.append(".")
            }
            formatString.append("\n")
        }
        print(formatString, separator: " ", terminator: "")
    }
}
