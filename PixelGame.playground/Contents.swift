//: A SpriteKit based Playground

import PlaygroundSupport
import SpriteKit

let vc = GameViewController()
GameViewController.shared = vc

let sceneView = SKView(frame: CGRect(x:0 , y:0, width: 720, height: 480))

let scene = GameScene(size: sceneView.frame.size)
scene.scaleMode = .aspectFit

sceneView.presentScene(scene)

vc.view = sceneView

if let view = vc.view as? SKView {
    view.showsPhysics = true
    view.showsNodeCount = true
    view.showsFPS = true
}

PlaygroundPage.current.liveView = vc.view
