//
//  CodeScreen.swift
//  PixelGame
//
//  Created by Murilo Teixeira on 06/04/20.
//  Copyright © 2020 Murilo Teixeira. All rights reserved.
//

import SpriteKit

public class CodeScreen: SKSpriteNode {
    
    private var codeLines: [Int:String]!
    
    private let initialY: CGFloat = -60
    private lazy var currentY = initialY
    
    var labels = [Int:SKLabelNode]()
    var labelOrder = [Int]()
    
    var buttonsPressed = [NSButton]()
    
    convenience init(size: CGSize, codeLines: [Int:String]) {
        self.init()
        self.codeLines = codeLines
        self.size = size
        color = .black
        name = NodeName.codeScreen.rawValue
        zPosition = NodesZPosition.codeScreen.rawValue
        
        generateLabels()
        labelOrder = labelOrder.shuffled()
        insertCodeLines()
    }
    
    private func generateLabels() {
        for (key, value) in codeLines {
            let label = SKLabelNode(text: kFontName)
            label.text = "\(key + 1) \(value)"
            label.horizontalAlignmentMode = .left
            label.name = "\(key)"
            labels[key] = label
            labelOrder.append(key)
        }
    }
    
    private func insertCodeLines() {
        for i in 0..<labelOrder.count {
            labels[labelOrder[i]]?.position = CGPoint(x: 0, y: currentY)
            addChild(labels[i]!)
            currentY += 35
        }
    }
    
}

extension CodeScreen: TouchBarSubscriber {
    func buttonTapped(_ notificationType: TouchBarNotificationType, with button: NSButton? = nil) {
        guard let button = button else { return }
        
        switch notificationType {
        case .numberButton:
            if buttonsPressed.count == 0 {
                buttonsPressed.append(button)
            }
            else if buttonsPressed.count == 1 {
                buttonsPressed.append(button)
                
                guard let button1 = Int(buttonsPressed[0].title), let button2 = Int(buttonsPressed[1].title) else { return }
                let originIndex = labelOrder.filter{$0 == button1 - 1}.first!
                let destinyIndex = labelOrder.filter{$0 == button2 - 1}.first!

                let originLabel = labels[originIndex]
                let destinyLabel = labels[destinyIndex]

                let originPosition = originLabel?.position
                originLabel?.position = destinyLabel!.position
                destinyLabel?.position = originPosition!
                
                let index = labelOrder[destinyIndex]
                labelOrder[destinyIndex] = labelOrder[originIndex]
                labelOrder[originIndex] = index
                                
                let button1Frame = buttonsPressed[0].frame
                let button2Frame = buttonsPressed[1].frame
                buttonsPressed[0].frame = button2Frame
                buttonsPressed[1].frame = button1Frame
                
                buttonsPressed.removeAll()
            }
        default:
            break
        }
    }
    
    public override var description: String { "CodeScreen" }
}
