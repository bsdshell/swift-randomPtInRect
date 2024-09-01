//
//  GameScene.swift
//  swift-randomPtInRect
//
//  Created by aaa on 2024-08-26.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    private var label : SKLabelNode?
    private var spinnyNode : SKShapeNode?
    private var frameMarginW : CGFloat = 0.8
    private var frameMarginH : CGFloat = 0.9
    private var gameSize : CGSize = CGSize(width: 0.0, height: 0.0)
    private var topLeft : CGPoint = CGPoint(x:0, y:0)
    private var bottomRight : CGPoint = CGPoint(x:0, y:0)
    private var powerTopLeft : CGPoint = CGPoint(x:0, y:0)
    private var initTime0 : TimeInterval = -10.0
    
    override func didMove(to view: SKView) {
        
        // Get label node from scene and store it for use later
        self.label = self.childNode(withName: "//helloLabel") as? SKLabelNode
        if let label = self.label {
            label.alpha = 0.0
            label.run(SKAction.fadeIn(withDuration: 2.0))
        }
        
        // Create shape node to use during mouse interaction
        let w = (self.size.width + self.size.height) * 0.05
        self.spinnyNode = SKShapeNode.init(rectOf: CGSize.init(width: w, height: w), cornerRadius: w * 0.3)
        
        if let spinnyNode = self.spinnyNode {
            spinnyNode.lineWidth = 2.5
            
            spinnyNode.run(SKAction.repeatForever(SKAction.rotate(byAngle: CGFloat(Double.pi), duration: 1)))
            spinnyNode.run(SKAction.sequence([SKAction.wait(forDuration: 0.5),
                                              SKAction.fadeOut(withDuration: 0.5),
                                              SKAction.removeFromParent()]))
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        let w = self.size.width * frameMarginW
        let h = self.size.height * frameMarginH
        gameSize = CGSize(width: w, height: h)
        
        topLeft = CGPoint(x : 0 - gameSize.width/2, y: gameSize.height/2)
        bottomRight = CGPoint(x : 0 + gameSize.width/2, y : 0 - gameSize.height/2)

        powerTopLeft = topLeft + CGPoint(x:40, y:-40)
        
        let rectNode = SKShapeNode.init(rectOf: CGSize.init(width: gameSize.width, height: gameSize.height), cornerRadius: gameSize.width * 0.01)
        self.addChild(rectNode)
        
        let topleftCircle = Ball(position: topLeft, radius: 10.0)
        topleftCircle.draw()
        topleftCircle.fillColor = UIColor.green
        self.addChild(topleftCircle.getNode())

        let topRight = topLeft + CGVector(dx:gameSize.width, dy:0)
        let topRightCircle = Ball(position: topRight, radius: 10.0)
        topRightCircle.draw()
        topRightCircle.fillColor = UIColor.red
        self.addChild(topRightCircle.getNode())

        let bottomRightCircle = Ball(position: bottomRight, radius: 10.0)
        bottomRightCircle.draw()
        bottomRightCircle.fillColor = UIColor.blue
        self.addChild(bottomRightCircle.getNode())

        let bottomLeft = bottomRight - CGVector(dx : gameSize.width, dy:0)
        let bottomLeftCircle = Ball(position: bottomLeft, radius: 10.0)
        bottomLeftCircle.draw()
        bottomLeftCircle.fillColor = UIColor.white
        self.addChild(bottomLeftCircle.getNode())

        
        let ls = tails(list:[0, 1, 2, 3])
        print("ls => \(ls)")
        
        let lv = combine(num: 2, list: [0, 1, 2, 3])
        print("lv => \(lv)")

        let lw = combine(num: 1, list: [0, 1, 2, 3])
        print("lw => \(lw)")
        
        
        let vec0 = nr(vec:CGVector(dx:0, dy:1))
        print("vec0 => \(vec0)")

        let vec1 = nr(vec:CGVector(dx:1, dy:1))
        print("vec1 => \(vec1)")

        let p0 = CGPoint(x:1, y:0)
        let p1 = CGPoint(x:0, y:0)
        let p2 = CGPoint(x:0, y:1)

        let ang = cosVex3(pt0:p0, pt1:p1, pt2:p2)
        print("ang => \(ang)")

    }

    func randomPtRect(topLeft:CGPoint, width:CGFloat, height:CGFloat) -> CGPoint{
        let rx = CGFloat.random(in: 0...1.0)
        let ry = CGFloat.random(in: 0...1.0)
        return CGPoint(x : topLeft.x + width * rx, y : topLeft.y - height * ry)
    }
    
    
    func touchDown(atPoint pos : CGPoint) {
        if let n = self.spinnyNode?.copy() as! SKShapeNode? {
            n.position = pos
            n.strokeColor = SKColor.green
            self.addChild(n)
        }
    }
    
    func touchMoved(toPoint pos : CGPoint) {
        if let n = self.spinnyNode?.copy() as! SKShapeNode? {
            n.position = pos
            n.strokeColor = SKColor.blue
            self.addChild(n)
        }
    }
    
    func touchUp(atPoint pos : CGPoint) {
        if let n = self.spinnyNode?.copy() as! SKShapeNode? {
            n.position = pos
            n.strokeColor = SKColor.red
            self.addChild(n)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let label = self.label {
            label.run(SKAction.init(named: "Pulse")!, withKey: "fadeInOut")
        }
        
        for t in touches { self.touchDown(atPoint: t.location(in: self)) }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchMoved(toPoint: t.location(in: self)) }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    

    func randomTwoPts(dt:CGFloat) -> (CGPoint, CGPoint){
        var done = true
        var ret : (CGPoint, CGPoint) = (CGPoint(x:0, y:0), CGPoint(x:0, y:0))
        while done {
            var ls :[CGPoint] = []
            for n in 0...4{
                let pt = randomPtRect(topLeft: self.topLeft, width: self.gameSize.width/2, height: gameSize.height/2)
                ls.append(pt)
            }
            let lv = combine(num:2, list:ls)
            
            for lt in lv{
                let d = dist(vec: lt[0] - lt[1])
                if d >= dt{
                    ret = (lt[0], lt[1])
                    done = false
                }
                
            }
        }
        return ret
    }

    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
        if initTime0 < -1.0{
            initTime0 = currentTime
        }else{
            let diff = currentTime - initTime0
            if diff > 0.1{

                let (p0, p1) = randomTwoPts(dt:100)
                let pt = randomPtRect(topLeft: self.topLeft, width: self.gameSize.width/2, height: gameSize.height/2)
                                
                let topleftCircle = Ball(position: pt, radius: 10.0)
                topleftCircle.draw()
                let red  = CGFloat.random(in: 0...1.0)
                let green = CGFloat.random(in: 0...1.0)
                let blue = CGFloat.random(in: 0...1.0)
                topleftCircle.fillColor = UIColor(red: red, green: green, blue: blue, alpha: 1.0)
                self.addChild(topleftCircle.getNode())

                initTime0 = currentTime
            }
        }
        
    }
}
