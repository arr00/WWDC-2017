//: Playground - noun: a place where people can play

import UIKit
import PlaygroundSupport
import SpriteKit
import AVFoundation

/* Things left to do
 * 
 * Stop game upon winning
 * Show Percentages
 * Add falling apple employees
 * Make Mac fly from random locations
 
 * Maybe set mac aspect ratios so they look better
 
 */

let gameDuration = 30.0




/*
 The Swift playground you submit should be created entirely by you as an individual. Group work will not be considered.
 Your Swift playground should be built using Swift Playgrounds on iPad or Xcode on macOS.
 Your Swift playground should function properly and run on the latest releases of Swift Playgrounds and iOS or Xcode and macOS.
 All content should be in English.
 Your .zip file size should not be more than 25 MB.
 Any resources in your project should be included locally in the .zip file that you provide, as your Swift playground will be judged offline.
*/
//let view = TestView(string: "")

//let view2 = UIView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))

let view3 = SKView(frame: CGRect(x: 0, y: 0, width: 500, height: 500))

///Valiable is updated when the user looses
var userLost = false

//Number of employees caught
var employeesCaught = 0

//Number of employees dropped
var employeesDropped = 0



var timer:Timer!
var percentageTimer:Timer!

view3.backgroundColor = UIColor.clear
view3.allowsTransparency = true


let testView = UIView(frame: view3.bounds)

testView.backgroundColor = UIColor.green

//Add moving background to testView to try to eliminate lag
let bg1ImageView = UIImageView(image: #imageLiteral(resourceName: "sky.png"))
let bg2ImageView = UIImageView(image: #imageLiteral(resourceName: "sky.png"))

bg1ImageView.frame.size = CGSize(width: testView.frame.size.height * 2.2, height: testView.frame.size.height)
bg2ImageView.frame.size = bg1ImageView.frame.size

bg1ImageView.frame.origin = CGPoint(x: 0, y: 0)
bg2ImageView.frame.origin = CGPoint(x: bg1ImageView.frame.size.width - 260, y: 0)

testView.addSubview(bg1ImageView)
testView.addSubview(bg2ImageView)

UIView.setAnimationCurve(.linear)

func animateImageView1(view:UIView,otherView:UIView) {
    UIView.animate(withDuration: Double(view.frame.origin.x + view.frame.width)/100.0, delay: 0, options: .curveLinear, animations: {
        view.frame.origin.x = -view.frame.size.width
    }) { (finished) in
        if finished {
            view.frame.origin.x = (otherView.layer.presentation()?.frame.origin.x)! + otherView.frame.size.width - 260
            animateImageView1(view: view, otherView: otherView)
        }
    }
    
}

animateImageView1(view: bg1ImageView, otherView: bg2ImageView)
animateImageView1(view: bg2ImageView, otherView: bg1ImageView)


testView.addSubview(view3)



//Add loader
let loaderBg = UIImageView(image: #imageLiteral(resourceName: "loaderBg.png"))
loaderBg.frame.size = CGSize(width: 300, height: 20)
loaderBg.center = CGPoint(x: view3.frame.size.width/2, y: view3.frame.size.height - 30)
loaderBg.contentMode = .scaleAspectFit

let progressBar = UIImageView(image: #imageLiteral(resourceName: "progressBar.png"))
progressBar.frame.size = CGSize(width: 0, height: 8)
progressBar.frame.origin.x = 4
progressBar.center.y = loaderBg.frame.size.height/2
progressBar.contentMode = .scaleToFill
progressBar.layer.cornerRadius = 5
progressBar.layer.masksToBounds = true

func removeProgressBarProgress() {
    let width = progressBar.frame.size.width
    progressBar.layer.removeAllAnimations()
    progressBar.frame.size.width = width
    UIView.animate(withDuration: 0.6) {
        progressBar.frame.size.width = 0
    }
}

UIView.setAnimationCurve(.linear)

/*UIView.animate(withDuration: gameDuration, animations: {
    progressBar.frame.size.width = 292
}) { (complete) in
    print("Finished game")
    
    if complete {
    timer.invalidate()
    
    
        let popupView = UIView(frame: CGRect(x: 10, y: 10, width: 400, height: 100))
        popupView.backgroundColor = UIColor.white
        popupView.alpha = 0.4
        popupView.layer.cornerRadius = 20
        popupView.center.x = view3.frame.width/2
        popupView.center.y = view3.frame.height/2
    
    
        print("Animation was completed? \(complete)")
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 400, height: 100))
        label.text = "You Won! \nReload the Playground to play again \nThank you for checking out my project!"
        label.numberOfLines = 3
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 20)
    
    
        popupView.addSubview(label)

        view3.addSubview(popupView)
    }
}*/





loaderBg.addSubview(progressBar)
view3.addSubview(loaderBg)

//Create intro here

let popupView = UIView(frame: CGRect(x: 10, y: 10, width: 400, height: 100))
popupView.backgroundColor = UIColor.white
popupView.alpha = 0.4
popupView.layer.cornerRadius = 20
popupView.center.x = view3.frame.width/2
popupView.frame.origin.y = 20

let label = UILabel(frame: CGRect(x: 0, y: 0, width: 400, height: 100))
label.text = "WWDC17 \n - Tap and drag on the airplane to move it around\n - Dodge the Macs \n - Bring the Apple employees to the WWDC!"
label.numberOfLines = 4
label.textAlignment = .center


popupView.addSubview(label)

view3.addSubview(popupView)



//Create percentage counter
//Create percentage label
class PercentageLabel: UILabel {
    var percent = 0
    
    init(initialPercent:Int) {
        super.init(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        self.font = UIFont.systemFont(ofSize: 15)
        self.textColor = UIColor.black
        self.text = "\(initialPercent)%"
        percent = initialPercent
        
    }
    override func didMoveToSuperview() {
        self.center.x = (self.superview?.frame.size.width)!/2
        self.frame.origin.y = (self.superview?.frame.size.height)! - 35
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func updatePercentage(percent:Int) {
        self.text = "\(percent)%"
        self.percent = percent
        
        
    }
    func addOnePercent() {
        percent += 1
        self.text = "\(percent)%"
        
    }
}



//Add percentageLabel
let percentageLabel = PercentageLabel(initialPercent: 0)

view3.addSubview(percentageLabel)










class GameScene: SKScene, SKPhysicsContactDelegate {
    var airplane:SKSpriteNode!
    var macCounter = 0
    let category: UInt32 = 3
    let category2: UInt32 = 2
    let category3: UInt32 = 1
    let employeeCategory: UInt32 = 0
    
    
    override func didMove(to view: SKView) {
    
        self.backgroundColor = UIColor.clear
        
        //initalize scene
        self.scaleMode = .aspectFit
        self.size = CGSize(width: 500, height: 500)
        self.physicsWorld.contactDelegate = self
        
        
        //Create scrolling background
        
        
        
        
        
        
        //create airplane
        airplane = SKSpriteNode()
        airplane.zPosition = 1.2
        
        
        let texture = SKTexture(image: #imageLiteral(resourceName: "airplane2.png"))
        airplane.texture = texture
        
        airplane.size = CGSize(width: 150, height: 70)
        airplane.position = CGPoint(x: 130, y: 250)
        airplane.physicsBody = SKPhysicsBody(circleOfRadius: airplane.size.width/2)
        airplane.physicsBody?.affectedByGravity = false
        airplane.physicsBody?.allowsRotation = false
        airplane.physicsBody?.usesPreciseCollisionDetection = false
        airplane.physicsBody?.categoryBitMask = category
        //airplane.physicsBody?.mass = 9999999999999999
        airplane.physicsBody?.contactTestBitMask = category2 | employeeCategory
        airplane.physicsBody?.collisionBitMask = 0
        
        self.physicsWorld.gravity = CGVector(dx: 0, dy: -1)
        
        
        //Add airplaneNode
        self.addChild(airplane)
        
        
        //animateBg2()
        
        
        //Create floor node items that hit dissapear
        let floor = SKSpriteNode(color: .red, size: CGSize(width: 1000, height: 10))
        floor.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 1000, height: 10))
        
        floor.position = CGPoint(x: -20, y: -200)
        floor.physicsBody?.pinned = true
        floor.physicsBody?.allowsRotation = false
        floor.physicsBody?.categoryBitMask = category3
        floor.physicsBody?.contactTestBitMask = category2 | employeeCategory
        self.addChild(floor)
        
        
        
        
        //Add text nodes
        let teaneckNode = SKLabelNode(text: "Teaneck")
        teaneckNode.fontSize = 20
        teaneckNode.fontName = ".SFUIText"
        teaneckNode.position = CGPoint(x: 50, y: 25)
        teaneckNode.fontColor = UIColor.black
        self.addChild(teaneckNode)
        
        let sanJoseNode = SKLabelNode(text: "San Jose")
        sanJoseNode.fontSize = 20
        sanJoseNode.fontName = ".SFUIText"
        sanJoseNode.position = CGPoint(x: self.frame.width - 50, y: 25)
        sanJoseNode.fontColor = UIColor.black
        self.addChild(sanJoseNode)
        
        
        //Begin game
        startScene()
    }
    
    func startScene() {
        timer = Timer.scheduledTimer(withTimeInterval: 4.0, repeats: true) { (time) in
            self.launchMac()
            self.dropEmployee()
        }
        
        percentageTimer = Timer.scheduledTimer(withTimeInterval: gameDuration/100, repeats: true, block: { (privateTimer) in
        
            percentageLabel.addOnePercent()
            progressBar.frame.size.width = CGFloat(percentageLabel.percent)/100.0 * 292.0
            print(CGFloat(percentageLabel.percent)/100.0 * 292.0)

            if percentageLabel.percent == 100 || userLost {
                timer.invalidate()
                privateTimer.invalidate()
                
                
                
                if percentageLabel.percent == 100 {
                    //user won
                    let backgroundNode = SKNode()
                    
                    
                    
                    let label = SKLabelNode(text: "You Won!")
                    label.fontSize = 20
                    label.position = CGPoint(x: self.frame.size.width/2, y: self.frame.size.height/2 + 25 - label.frame.size.height/2)
                    label.fontColor = UIColor.black
                    label.fontName = ".SFUIText"
                    label.alpha = 0.6
                    
                    let label2 = SKLabelNode(text: "Reload the Playground to play again")
                    label2.fontSize = 20
                    label2.position = CGPoint(x: self.frame.size.width/2, y: self.frame.size.height/2 - label2.frame.size.height/2)
                    label2.fontColor = UIColor.black
                    label2.fontName = ".SFUIText"
                    label2.alpha = 0.6
                    
                    let label3 = SKLabelNode(text: "Thank you for checking out my project!")
                    label3.fontSize = 20
                    label3.position = CGPoint(x: self.frame.size.width/2, y: self.frame.size.height/2 - 25 - label3.frame.size.height/2)
                    label3.fontColor = UIColor.black
                    label3.fontName = ".SFUIText"
                    label3.alpha = 0.6
                    
                    let label4 = SKLabelNode(text: "\(employeesCaught)/\(employeesDropped) employees caught")
                    label4.fontSize = 20
                    label4.position = CGPoint(x: self.frame.size.width/2, y: self.frame.size.height/2 - 50 - label4.frame.size.height/2)
                    label4.fontColor = UIColor.black
                    label4.fontName = ".SFUIText"
                    label4.alpha = 0.6
                    
                    
                    let background = SKShapeNode(rect: CGRect(x: 0, y: 0, width: label3.frame.size.width + 20, height: 125), cornerRadius: 20)
                    background.fillColor = UIColor.white
                    background.strokeColor = UIColor.clear
                    background.position = CGPoint(x: self.frame.size.width/2 - background.frame.width/2, y: self.frame.size.height/2 - background.frame.height/2 - 12.5)
                    background.alpha = 0.4
                    
                    
                    backgroundNode.addChild(background)
                    backgroundNode.addChild(label)
                    backgroundNode.addChild(label2)
                    backgroundNode.addChild(label3)
                    backgroundNode.addChild(label4)
                    
                    
                    
                    
                    let animation = SKAction.fadeAlpha(to: 1.0, duration: 1.0)
                    backgroundNode.run(animation)
                    
                    self.addChild(backgroundNode)

                }
                
                
                
                
                
            }
        })
        
        

        
    }
    
    /*
    func animateBg1() {
        let bgAnimation = SKAction.moveTo(x: -bg1.frame.size.width, duration: 4.0)
        bg1.run(bgAnimation) {
            self.bg1.position.x = self.bg2.size.width
            self.animateBg1Again()
        }
    }
    
    func animateBg1Again() {
        let bgAnimation = SKAction.moveTo(x: -bg1.frame.size.width, duration: 8.0)
        bg1.run(bgAnimation) {
            self.bg1.position.x = self.bg2.size.width
            self.animateBg1Again()
        }
        
    }
    
    func animateBg2() {
        let bgAnimation = SKAction.moveTo(x: -bg1.frame.size.width, duration: 8.0)
        bg2.run(bgAnimation) {
            self.bg2.position.x = self.bg1.size.width
            self.animateBg2()
        }
        
    }
    */
    
    
  
    
    
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
        
        else if (contact.bodyA.categoryBitMask == employeeCategory && contact.bodyB.categoryBitMask == category) {
            //BodyA is Employee
            //BodyB is Airplane
            print("Got Employee")
            
            //Remove employee from scene
            contact.bodyA.node?.removeFromParent()
        }
        else if (contact.bodyB.categoryBitMask == employeeCategory && contact.bodyA.categoryBitMask == category) {
            //BodyB is Employee
            //BodyA is Airplane
            print("Got Employee2")
            
            //Remove employee from scene
            contact.bodyB.node?.removeFromParent()
            employeesCaught += 1
            
            
        }
        
        
    }
    
    func blowUpAirplane() {
        
        let fireBallTexture = SKTexture(image: #imageLiteral(resourceName: "fireBall.png"))
        let fireBall = SKSpriteNode(texture: fireBallTexture)
        fireBall.size = CGSize(width: airplane.size.width + 100, height: airplane.size.height + 40)
        fireBall.position = airplane.position
        fireBall.zPosition = 2
        fireBall.physicsBody = SKPhysicsBody(circleOfRadius: fireBall.size.height/2)
        fireBall.physicsBody?.allowsRotation = false
        fireBall.physicsBody?.affectedByGravity = true
        fireBall.physicsBody?.collisionBitMask = 0
        
        
        
        self.addChild(fireBall)
        
        
        /* Add message saying
         * You Lost
         * Reload Playground to play again
         * Thanks for checking out my project!
         */
        let backgroundNode = SKNode()
        
        
        
        let label = SKLabelNode(text: "You Lost")
        label.fontSize = 20
        label.position = CGPoint(x: self.frame.size.width/2, y: self.frame.size.height/2 + 25 - label.frame.size.height/2)
        label.fontColor = UIColor.black
        label.fontName = ".SFUIText"
        label.alpha = 0.6
        
        let label2 = SKLabelNode(text: "Reload the Playground to play again")
        label2.fontSize = 20
        label2.position = CGPoint(x: self.frame.size.width/2, y: self.frame.size.height/2 - label2.frame.size.height/2)
        label2.fontColor = UIColor.black
        label2.fontName = ".SFUIText"
        label2.alpha = 0.6
        
        let label3 = SKLabelNode(text: "Thank you for checking out my project!")
        label3.fontSize = 20
        label3.position = CGPoint(x: self.frame.size.width/2, y: self.frame.size.height/2 - 25 - label3.frame.size.height/2)
        label3.fontColor = UIColor.black
        label3.fontName = ".SFUIText"
        label3.alpha = 0.6
        
        let label4 = SKLabelNode(text: "\(employeesCaught)/\(employeesDropped) employees caught")
        label4.fontSize = 20
        label4.position = CGPoint(x: self.frame.size.width/2, y: self.frame.size.height/2 - 50 - label4.frame.size.height/2)
        label4.fontColor = UIColor.black
        label4.fontName = ".SFUIText"
        label4.alpha = 0.6
        
        
        let background = SKShapeNode(rect: CGRect(x: 0, y: 0, width: label3.frame.size.width + 20, height: 125), cornerRadius: 20)
        background.fillColor = UIColor.white
        background.strokeColor = UIColor.clear
        background.position = CGPoint(x: self.frame.size.width/2 - background.frame.width/2, y: self.frame.size.height/2 - background.frame.height/2 - 12.5)
        background.alpha = 0.4
        
        
        backgroundNode.addChild(background)
        backgroundNode.addChild(label)
        backgroundNode.addChild(label2)
        backgroundNode.addChild(label3)
        backgroundNode.addChild(label4)
        
        
        
        
        let animation = SKAction.fadeAlpha(to: 1.0, duration: 1.0)
        backgroundNode.run(animation)
        
        self.addChild(backgroundNode)
        
        
        
        
        timer.invalidate()
        
        /*
         let width = progressBar.frame.size.width
         progressBar.layer.removeAllAnimations()
         progressBar.frame.size.width = width
         UIView.animate(withDuration: 0.6) {
         progressBar.frame.size.width = 0
         }
        */
        
        userLost = true
       
         
    }
    
    
    func dropEmployee() {
        
        
        let employeeTextures = [SKTexture(image: #imageLiteral(resourceName: "Group2.png")),SKTexture(image: #imageLiteral(resourceName: "jonyIve.png"))]
        let employee = SKSpriteNode(texture: employeeTextures[employeesDropped % employeeTextures.count])
        
        employee.physicsBody = SKPhysicsBody(circleOfRadius: employee.frame.size.width/2)
        employee.physicsBody?.affectedByGravity = true
        employee.physicsBody?.allowsRotation = false
        employee.physicsBody?.categoryBitMask = employeeCategory
        employee.physicsBody?.contactTestBitMask = category
        employee.physicsBody?.collisionBitMask = 0
        employee.position = CGPoint(x: CGFloat(arc4random_uniform(UInt32((self.frame.size.width) - (2.0 * employee.size.width)))) + employee.size.width, y: self.frame.size.height + 10)
        employee.physicsBody?.friction = 100
        self.addChild(employee)
        
        employeesDropped += 1
    }
    
    func launchMac() {
        
        
        let macTextures = [SKTexture(image: #imageLiteral(resourceName: "mac1.png")),SKTexture(image: #imageLiteral(resourceName: "mac2.png")),SKTexture(image: #imageLiteral(resourceName: "mac3.png")),SKTexture(image: #imageLiteral(resourceName: "mac4.png")),SKTexture(image: #imageLiteral(resourceName: "mac5.png")),SKTexture(image: #imageLiteral(resourceName: "mac6.png")),SKTexture(image: #imageLiteral(resourceName: "mac7.png")),SKTexture(image: #imageLiteral(resourceName: "mac8.png")),SKTexture(image: #imageLiteral(resourceName: "mac9.png")),SKTexture(image: #imageLiteral(resourceName: "mac10.png")),SKTexture(image: #imageLiteral(resourceName: "mac11.png")),SKTexture(image: #imageLiteral(resourceName: "mac13.png")),SKTexture(image: #imageLiteral(resourceName: "mac13.png"))]
        
        let macNode = SKSpriteNode(texture: macTextures[macCounter])
        
        macNode.size = CGSize(width: 70, height: 50)
        macNode.physicsBody = SKPhysicsBody(circleOfRadius: macNode.frame.size.width/2)
        //macNode.physicsBody?.mass = 100000000000000
        
        
        let throwLocation = arc4random_uniform(3)
        print(throwLocation)
        //0 is bottom
        //1 is top
        //2 is middle
        
        if(throwLocation == 1) {
            macNode.position = CGPoint(x: self.frame.size.width + 10, y: -10)
            macNode.physicsBody?.velocity = CGVector(dx: -200, dy: 200)
        }
        
        else if (throwLocation == 2) {
            macNode.position = CGPoint(x: self.frame.size.width + 10, y: self.frame.size.height + 10)
            macNode.physicsBody?.velocity = CGVector(dx: -200, dy: 0)
        }
        else {
            macNode.position = CGPoint(x: self.frame.size.width + 10, y: self.frame.height/2 + 10)
            macNode.physicsBody?.velocity = CGVector(dx: -200, dy: 10)
        }
        
        
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







let scene = GameScene()
view3.presentScene(scene)
view3.showsFPS = true
view3.showsNodeCount = true
view3.showsFields = true
view3.showsQuadCount = true




//Start playing music

let audioPath = Bundle.main.path(forResource: "wwdcAudio", ofType: "mp3")
let audioUrl = URL(fileURLWithPath: audioPath!)
let audioPlayer = try AVAudioPlayer(contentsOf: audioUrl)
audioPlayer.play()
audioPlayer.numberOfLoops = -1






PlaygroundPage.current.liveView = testView
