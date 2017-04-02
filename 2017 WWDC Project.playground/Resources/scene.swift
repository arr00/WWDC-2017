import Foundation
import SpriteKit
import UIKit

var timer:Timer!

class GameScene2: SKScene, SKPhysicsContactDelegate {
    var airplane:SKSpriteNode!
    var bg1:SKSpriteNode!
    var bg2:SKSpriteNode!
    var macCounter = 0
    let category: UInt32 = 3
    let category2: UInt32 = 2
    let category3: UInt32 = 1
    
    
    override func didMove(to view: SKView) {
        
        
        //initalize scene
        self.scaleMode = .aspectFit
        self.size = CGSize(width: 500, height: 500)
        self.physicsWorld.contactDelegate = self
        
        
        //Create scrolling background
        let bgTexture = SKTexture(image: #imageLiteral(resourceName: "skyBg.jpg"))
        bg1 = SKSpriteNode(texture: bgTexture)
        bg2 = SKSpriteNode(texture: bgTexture)
        
        bg1.anchorPoint = CGPoint.zero
        bg1.position = CGPoint(x: 0, y: 0)
        bg1.zPosition = -1
        self.addChild(bg1)
        
        bg2.anchorPoint = CGPoint.zero
        bg2.position = CGPoint(x: bg1.size.width, y: 0)
        bg2.zPosition = -2
        self.addChild(bg2)
        
        
        
        
        
        //create airplane
        airplane = SKSpriteNode()
        airplane.zPosition = 1.2
        
        
        let texture = SKTexture(image: #imageLiteral(resourceName: "airplane.png"))
        airplane.texture = texture
        
        airplane.size = CGSize(width: 150, height: 100)
        airplane.position = CGPoint(x: 130, y: 250)
        airplane.physicsBody = SKPhysicsBody(circleOfRadius: airplane.size.width/2)
        airplane.physicsBody?.affectedByGravity = false
        airplane.physicsBody?.allowsRotation = false
        airplane.physicsBody?.usesPreciseCollisionDetection = false
        airplane.physicsBody?.categoryBitMask = category
        //airplane.physicsBody?.mass = 9999999999999999
        airplane.physicsBody?.contactTestBitMask = category2
        airplane.physicsBody?.collisionBitMask = 0
        
        self.physicsWorld.gravity = CGVector(dx: 0, dy: -1)
        
        
        //Add airplaneNode
        self.addChild(airplane)
        
        
        //animateBg2()
        
        
        //Create floor node items that hit dissapear
        let floor = SKSpriteNode(color: .red, size: CGSize(width: 700, height: 10))
        floor.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 700, height: 10))
        
        floor.position = CGPoint(x: 400, y: -200)
        floor.physicsBody?.pinned = true
        floor.physicsBody?.allowsRotation = false
        floor.physicsBody?.categoryBitMask = category3
        floor.physicsBody?.contactTestBitMask = category2
        self.addChild(floor)
        
        
        
        
        //Add text nodes
        let teaneckNode = SKLabelNode(text: "Teaneck")
        teaneckNode.fontSize = 20
        teaneckNode.position = CGPoint(x: 50, y: 25)
        teaneckNode.fontColor = UIColor.black
        self.addChild(teaneckNode)
        
        let sanJoseNode = SKLabelNode(text: "San Jose")
        sanJoseNode.fontSize = 20
        sanJoseNode.position = CGPoint(x: self.frame.width - 50, y: 25)
        sanJoseNode.fontColor = UIColor.black
        self.addChild(sanJoseNode)
        
        
        //Begin game
        startScene()
    }
    
    func startScene() {
        timer = Timer.scheduledTimer(withTimeInterval: 4.0, repeats: true) { (time) in
            self.launchMac()
        }
        //animateBg1()
    }
    
    func animateBg1() {
        let bgAnimation = SKAction.moveTo(x: -bg1.frame.size.width, duration: 2.0)
        bg1.run(bgAnimation) {
            self.bg1.position.x = self.bg2.size.width
            self.animateBg1Again()
        }
    }
    
    func animateBg1Again() {
        let bgAnimation = SKAction.moveTo(x: -bg1.frame.size.width, duration: 4.0)
        bg1.run(bgAnimation) {
            self.bg1.position.x = self.bg2.size.width
            self.animateBg1Again()
        }
        
    }
    
    func animateBg2() {
        let bgAnimation = SKAction.moveTo(x: -bg1.frame.size.width, duration: 4.0)
        bg2.run(bgAnimation) {
            self.bg2.position.x = self.bg1.size.width
            self.animateBg2()
        }
        
    }
    
    
    
    func backgroundScrollUpdate() {
        bg1.position = CGPoint(x: bg1.position.x - 200, y: bg1.position.y)
        bg2.position = CGPoint(x: bg2.position.x - 200, y: bg2.position.y)
        
        
        if bg1.position.x + bg1.size.width <= 0 {
            bg1.position.x = bg2.position.x + bg2.frame.size.width
        }
            
        else if bg2.position.x + bg2.size.width <= 0 {
            
            bg2.position.x = bg1.position.x + bg1.frame.size.width
        }
        
    }
    
    /*
     override func update(_ currentTime: TimeInterval) {
     backgroundScrollUpdate()
     }*/
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            airplane.position = touch.location(in: self)
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            airplane.position = touch.location(in: self)
        }
        
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        print("Contact")
        if contact.bodyA.categoryBitMask == category3 {
            contact.bodyB.node?.removeFromParent()
        }
        else if contact.bodyB.categoryBitMask == category3 {
            contact.bodyA.node?.removeFromParent()
        }
        else if (contact.bodyA.categoryBitMask == category && contact.bodyB.categoryBitMask == category2) {
            //BodyA is plane
            //BodyB is danger
            print("Danger and Plane collision")
            contact.bodyB.node?.removeFromParent()
            contact.bodyA.node?.removeFromParent()
            blowUpAirplane()
        }
        else if (contact.bodyA.categoryBitMask == category2 && contact.bodyB.categoryBitMask == category) {
            //BodyA is danger
            //BodyB is Plane
            contact.bodyA.node?.removeFromParent()
            
            contact.bodyB.node?.removeFromParent()
            blowUpAirplane()
        }
        
        
    }
    
    func blowUpAirplane() {
        
        let fireBallTexture = SKTexture(image: #imageLiteral(resourceName: "fireBall.png"))
        let fireBall = SKSpriteNode(texture: fireBallTexture)
        fireBall.size = CGSize(width: airplane.size.width + 100, height: airplane.size.height + 20)
        fireBall.position = airplane.position
        fireBall.zPosition = 2
        fireBall.physicsBody = SKPhysicsBody(circleOfRadius: fireBall.size.height/2)
        fireBall.physicsBody?.allowsRotation = false
        fireBall.physicsBody?.affectedByGravity = true
        fireBall.physicsBody?.collisionBitMask = 0
        
        
        
        self.addChild(fireBall)
        
        timer.invalidate()
        
        /*
        let width = progressBar.frame.size.width
        progressBar.layer.removeAllAnimations()
        progressBar.frame.size.width = width
        UIView.animate(withDuration: 0.6) {
            progressBar.frame.size.width = 0
        }
        */
    }
    
    func launchMac() {
        
        
        let macTextures = [SKTexture(image: #imageLiteral(resourceName: "mac1.png")),SKTexture(image: #imageLiteral(resourceName: "mac2.png")),SKTexture(image: #imageLiteral(resourceName: "mac3.png")),SKTexture(image: #imageLiteral(resourceName: "mac4.png")),SKTexture(image: #imageLiteral(resourceName: "mac5.png")),SKTexture(image: #imageLiteral(resourceName: "mac6.png")),SKTexture(image: #imageLiteral(resourceName: "mac7.png")),SKTexture(image: #imageLiteral(resourceName: "mac8.png")),SKTexture(image: #imageLiteral(resourceName: "mac9.png")),SKTexture(image: #imageLiteral(resourceName: "mac10.png")),SKTexture(image: #imageLiteral(resourceName: "mac11.png")),SKTexture(image: #imageLiteral(resourceName: "mac12.png")),SKTexture(image: #imageLiteral(resourceName: "mac13.png"))]
        let macNode = SKSpriteNode(texture: macTextures[macCounter])
        
        macNode.size = CGSize(width: 70, height: 50)
        macNode.physicsBody = SKPhysicsBody(circleOfRadius: macNode.frame.size.width/2)
        //macNode.physicsBody?.mass = 100000000000000
        
        macNode.position = CGPoint(x: -10, y: -10)
        macNode.physicsBody?.velocity = CGVector(dx: 200, dy: 200)
        macNode.physicsBody?.usesPreciseCollisionDetection = false
        macNode.physicsBody?.categoryBitMask = category2
        macNode.physicsBody?.contactTestBitMask = category | category3
        macNode.physicsBody?.collisionBitMask = 0
        
        
        self.addChild(macNode)
        
        macCounter += 1
        if macCounter > 12 {
            macCounter = 0
        }
    }
}
