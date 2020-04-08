//
//  CodeScreen.swift
//  PixelGame
//
//  Created by Murilo Teixeira on 06/04/20.
//  Copyright © 2020 Murilo Teixeira. All rights reserved.
//

import SpriteKit

public class CodeScreen: SKSpriteNode {
    private var _subscriberName: String!
    
    private var currentIndex = 0
    private var codeLines: [[String:Any]]!
    
    private let initialY: CGFloat = 52.5
    private lazy var currentY = initialY
    
    private let initialStrokeColor: SKColor = .hexadecimal(0xD0D0D0)
    private let initialLineWidth: CGFloat = 1
    
    var lines = [Int:SKShapeNode]()
    var labelOrder = [Int]()
    
    var buttonsPressed = [NSButton]()
    
    var timer: Timer?
    
    convenience init(position: CGPoint, size: CGSize, codeLines: [[String:Any]], name: String) {
        self.init()
        self._subscriberName = name
        self.codeLines = codeLines
        self.size = size
        self.position = position
        color = .black
        self.name = NodeName.codeScreen.rawValue
        zPosition = NodesZPosition.codeScreen.rawValue
                
//        update()
        generateLabels()
        insertCodeLines()

    }
    
    func update() {
//        generateLabels()
//        insertCodeLines()
        shuffleLabels()
        insertPositionY()
        (TouchBarScene.shared.stateMachine.currentState as? OrganizeCodeLine)?.reorderButtons()
    }
    
    private func generateLabels() {
        guard let codeLine = codeLines[currentIndex]["codeLines"] as? [Int:String] else { return }
        for (key, value) in codeLine {
            let label = SKLabelNode(fontNamed: kFontName)
            label.fontSize = 10
            label.fontColor = .hexadecimal(0x37E519)
            label.text = "\(key + 1)  \(value)"
            label.horizontalAlignmentMode = .left
            label.verticalAlignmentMode = .center
            label.name = "\(key)"
            
            let line = SKShapeNode(rect: CGRect(x: 0, y: 0, width: size.width * 0.825, height: 25), cornerRadius: 1)
            line.strokeColor = .hexadecimal(0xD0D0D0)
            line.lineWidth = 1
            line.zPosition = NodesZPosition.label.rawValue
            
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
        currentY = initialY
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
    public var subscriberName: String {
        get {
            self._subscriberName
        }
        set {
            self._subscriberName = newValue
        }
    }
    
    public func buttonTapped(_ notificationType: TouchBarNotificationType, with button: NSButton? = nil) {
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
            guard let button1 = Int(button.title) else { return }
            buttonsPressed.append(button)
            
            lines[button1 - 1]?.flash(strokeColor: .green, count: 0)
            timer = button.flash(with: .hexadecimal(0x15CE5A))
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
            timer?.invalidate()
            
            for (_, shape) in lines {
                shape.removeAllActions()
                shape.lineWidth = initialLineWidth
                shape.strokeColor = initialStrokeColor
            }
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
        
        if organized {
            currentIndex += 1
            flash(with: .hexadecimal(0x50AC3A), timeInterval: 0.1) {
                GameScene.shared.stateMachine.enter(GameState.self)
            }
        }
        else {
//            self.shuffleLabels()
//            self.insertPositionY()
//            (TouchBarScene.shared.stateMachine.currentState as? OrganizeCodeLine)?.reorderButtons()
            update()
            (TouchBarScene.shared.stateMachine.currentState as? OrganizeCodeLine)?.hiddeButtons()
            flash(with: .red, count: 2, timeInterval: 0.1) {
                (TouchBarScene.shared.stateMachine.currentState as? OrganizeCodeLine)?.hiddeButtons(undo: true)
            }
            TouchBarScene.shared.notifyTouchBar(color: .red)
        }
    }
    
    public override var description: String { "CodeScreen" }
}
