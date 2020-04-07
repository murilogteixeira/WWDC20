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
    
    private let initialY: CGFloat = 20
    private lazy var currentY = initialY
    
    var lines = [Int:SKShapeNode]()
    var labelOrder = [Int]()
    
    var buttonsPressed = [NSButton]()
    
    lazy var titleLabel: SKLabelNode = {
        let label = SKLabelNode(fontNamed: kFontName)
        label.position = CGPoint(x: 0, y: size.height * 0.65)
        label.fontColor = .black
        label.fontSize = 10
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        label.verticalAlignmentMode = .center
        label.horizontalAlignmentMode = .center
        return label
    }()
    
    lazy var intructionLabel: SKLabelNode = {
        let label = SKLabelNode(fontNamed: kFontName)
        label.text = """
        Selecione na iTool a linha de origem e
        
         depois selecione a linha de destino
        
              para organizar o código!
        """
        label.position = CGPoint(x: 0, y: size.height * 0.3)
        label.fontColor = .white
        label.fontSize = 9
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        label.verticalAlignmentMode = .center
        label.horizontalAlignmentMode = .center
        return label
    }()
    
    convenience init(position: CGPoint, size: CGSize, data: [String:Any]) {
        self.init()
        self.size = size
        self.position = position
        color = .black
        name = NodeName.codeScreen.rawValue
        zPosition = NodesZPosition.codeScreen.rawValue
        
        addChild(titleLabel)
        addChild(intructionLabel)
        
        initData(data)
        generateLabels()
        shuffleLabels()
        insertPositionY()
        insertCodeLines()
    }
    
    private func initData(_ data: [String:Any]) {
        guard let title = data["title"] as? String,
            let codeLines = data["codeLines"] as? [Int:String] else { return }
        self.titleLabel.text = title
        self.codeLines = codeLines
    }
    
    private func generateLabels() {
        for (key, value) in codeLines {
            let label = SKLabelNode(fontNamed: kFontName)
            label.fontSize = 10
            label.fontColor = .green
            label.text = "\(key + 1)  \(value)"
            label.horizontalAlignmentMode = .left
            label.verticalAlignmentMode = .center
            label.name = "\(key)"
            
            let line = SKShapeNode(rect: CGRect(x: 0, y: 0, width: size.width * 0.825, height: 25), cornerRadius: 4)
            line.strokeColor = .hexadecimal(0xD0D0D0)
            line.lineWidth = 1
            
            label.position = CGPoint(x: (line.frame.width / 2) * 0.125, y: (line.frame.size.height / 2) * 0.85)
            
            line.addChild(label)
            lines[key] = line
            labelOrder.append(key)
        }
    }
    
    private func shuffleLabels() {
        labelOrder = labelOrder.shuffled()
        var shuffled = true
        for i in 0..<labelOrder.count {
            if i == labelOrder[i] {
                shuffled = false
            }
        }

        if !shuffled {
            shuffleLabels()
        }
    }
    
    private func insertPositionY() {
        for i in 0..<labelOrder.count {
            lines[labelOrder[i]]?.position = CGPoint(x: -(size.width / 2) * 0.825, y: currentY)
            currentY -= 32.5
        }
    }
    
    private func insertCodeLines() {
        for i in 0..<labelOrder.count {
            addChild(lines[i]!)
        }
    }
    
}

extension CodeScreen: TouchBarSubscriber {
    func buttonTapped(_ notificationType: TouchBarNotificationType, with button: NSButton? = nil) {
        guard let button = button else { return }
        
        switch notificationType {
        case .numberButton:
            numberPressed(button)
        case .playButton:
            runCode()
        default:
            break
        }
    }
    
    private func numberPressed(_ button: NSButton) {
        if buttonsPressed.count == 0 {
            buttonsPressed.append(button)
            button.bezelColor = .hexadecimal(0x17B352)
        }
        else {
            buttonsPressed.append(button)
            button.bezelColor = .hexadecimal(0x17B352)
            
            guard let button1 = Int(buttonsPressed[0].title), let button2 = Int(buttonsPressed[1].title) else { return }

            reorder(label: button1, to: button2)
            reorder(list: button1, to: button2)
            reorder(button: buttonsPressed[0], to: buttonsPressed[1])
            
            buttonsPressed.forEach { $0.bezelColor = .hexadecimal(0x0763CE) }
            buttonsPressed.removeAll()
        }
    }
    
    private func reorder(label from: Int, to: Int) {
        guard let fromLine = labelOrder.filter({$0 == from - 1}).first,
            let toLine = labelOrder.filter({$0 == to - 1}).first else { return }
        
        let originLabel = lines[fromLine]
        let destinyLabel = lines[toLine]

        let originPosition = originLabel?.position
        originLabel?.position = destinyLabel!.position
        destinyLabel?.position = originPosition!
    }
    
    private func reorder(list from: Int, to: Int) {
        guard let fromIndex = labelOrder.firstIndex(where: { $0 == from - 1 }),
            let toIndex = labelOrder.firstIndex (where: { $0 == to - 1 }) else { return }

        let index = labelOrder[fromIndex]
        labelOrder[fromIndex] = labelOrder[toIndex]
        labelOrder[toIndex] = index
    }
    
    private func reorder(button from: NSButton, to: NSButton) {
        let from = from.frame
        let to = to.frame
        buttonsPressed[0].frame = to
        buttonsPressed[1].frame = from
    }
    
    private func runCode() {
        var organized = true

        for i in 0..<labelOrder.count {
            if i != labelOrder[i] {
                organized = false
            }
        }
        print("Organized: ", organized)
    }
    
    public override var description: String { "CodeScreen" }
}
