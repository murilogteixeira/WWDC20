import Cocoa
import SpriteKit
import GameplayKit

public protocol GameSceneDelegate: AnyObject {
    func keyDown(_ gameScene: GameScene, keyCode: KeyCode?)
    func keyUp(_ gameScene: GameScene, keyCode: KeyCode?)
}

//MARK: GameScene
public class GameScene: SKScene {
    
    lazy var states = [
        IntroState(gameScene: self),
//        GameState(gameScene: self),
//        BuildRoomState(gameScene: self),
//        CreditsState(gameScene: self)
    ]
    
    lazy var gameState = GKStateMachine(states: self.states)
    
    lazy var controlNode: SKNode = {
        let node = SKNode()
        node.position = CGPoint.zero
        node.name = NodeName.controlNode.rawValue
        node.zPosition = NodesZPosition.controlNode.rawValue
        return node
    }()
    
    var directionPressed = KeyCode.none
    var upKey = Key(pressed: false, busy: false, name: .up)
    
    weak var delegateScene: GameSceneDelegate?
    
    public override func didMove(to view: SKView) {
        gameState.enter(IntroState.self)
        
        anchorPoint = CGPoint(x: 0.5, y: 0.5)
        
        addChild(controlNode)
    }
    
    // MARK: Update
    public override func update(_ currentTime: TimeInterval) {
        gameState.currentState?.update(deltaTime: currentTime)
    }
    
    public override init(size: CGSize) {
        super.init(size: size)
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}

// MARK: CustomKeyDown/Up
extension GameScene {
    public override func keyDown(with event: NSEvent) {
        delegateScene?.keyDown(self, keyCode: KeyCode(rawValue: event.keyCode))
    }
    
    public override func keyUp(with event: NSEvent) {
        delegateScene?.keyUp(self, keyCode: KeyCode(rawValue: event.keyCode))
    }
}
