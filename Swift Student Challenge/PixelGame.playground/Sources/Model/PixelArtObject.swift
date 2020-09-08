//
//  PixelArtObject.swift
//  PixelGame
//
//  Created by Murilo Teixeira on 31/03/20.
//  Copyright © 2020 Murilo Teixeira. All rights reserved.
//

import SpriteKit

//MARK: PixelArtObject
public class PixelArtObject: SKSpriteNode {
    private var format: [[SKColor]]! {
        didSet {
            removeAllChildren()
            build()
        }
    }
    
    var objectTexture: SKTexture {
        SKView().texture(from: self)!
    }
    
    var objectSpriteNode: SKSpriteNode {
        SKSpriteNode(texture: objectTexture)
    }
    
    // MARK: Init
    convenience init(format: [[SKColor]], size: CGSize) {
        self.init()
        self.format = format
        self.size = size
        build()
    }
    
    //MARK: Methods
    func build() {
        guard self.format != nil, size != .zero else { return }
        
        let rowCount = format.count
        let columnCount = format.first!.count
        
        let smallerSize = rowCount < columnCount ? columnCount : rowCount
        
        let pixelSize = size.width < size.height ? size.width / CGFloat(smallerSize) : size.height / CGFloat(smallerSize)
        
        let initialX: CGFloat = {
            var x = (-size.width + pixelSize) / 2
            if columnCount < rowCount {
                x += (CGFloat(rowCount - columnCount) / 2) * pixelSize
            }
            return x
        }()
        
        let initialY: CGFloat = {
            var y = (size.height - pixelSize) / 2
            if rowCount < columnCount {
                y -= (CGFloat(columnCount - rowCount) / 2) * pixelSize
            }
            return y
        }()
        
        var currentX: CGFloat = initialX
        var currentY: CGFloat = initialY
        
        for i in 0..<format.first!.count { // Row
            for j in 0..<format.count { // Column
                let pixel = SKSpriteNode(color: format[j][i], size: CGSize(width: pixelSize, height: pixelSize))
                pixel.position = CGPoint(x: currentX, y: currentY)
                currentY -= pixelSize
                addChild(pixel)
            }
            currentX += pixelSize
            currentY = initialY
        }
    }
    
}
