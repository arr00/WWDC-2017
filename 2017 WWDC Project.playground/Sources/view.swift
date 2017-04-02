import UIKit


public class TestView: UIView {
    
    public init(string:String) {
        
        super.init(frame: CGRect(x: 0, y: 0, width: 500, height: 500))
        self.backgroundColor = UIColor.red
        
        let view = WWDCAnimation(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        view.frame.origin = CGPoint(x: 100, y: 100)
        self.addSubview(view)
        
        //let scene = GameScene(size: CGSize(width: 100, height: 100))
        //let view2 = SKView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        //view2.presentScene(scene)
        
        //self.addSubview(view2)
        
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    public override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.backgroundColor = UIColor.getRandom()
    }
    
    
    public override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let circle = UIView(frame: CGRect(x: touch.location(in: self).x, y: touch.location(in: self).y, width: 10, height: 10))
            circle.layer.cornerRadius = 5
            circle.backgroundColor = UIColor.getRandom()
            self.addSubview(circle)
        }
        
        
    }
    
}

extension UIColor {
    
    static func getRandom() -> UIColor {
        let red = CGFloat(arc4random_uniform(100))/100.0
        let green = CGFloat(arc4random_uniform(100))/100.0
        let blue = CGFloat(arc4random_uniform(100))/100.0
        return UIColor(red: red, green: green, blue: blue, alpha: 1)
        
        
    }
    
    
}

