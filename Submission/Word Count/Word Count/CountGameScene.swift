//
//  GameScene.swift
//  temp
//
//  Created by Clint Sellen on 2/6/18.
//  Copyright © 2018 UTS. All rights reserved.
//

import SpriteKit
import GameplayKit

protocol CountGameSceneDelegate {
    func gameOver()
}

class CountGameScene: SKScene {
    // Declere view controller
    weak var viewController: CountGameViewController!
    var gameSceneDelegate: CountGameSceneDelegate?
//    View Constants
    var viewWidth = 1024
    var viewHeight = 750
//    Animiated Background
    var backgroundSpeed: CGFloat = 200.0 // Speed of background
    var deltaTime: TimeInterval = 0
    var lastUpdateTimeInterval: TimeInterval = 0
    // Game timer menu
    let clockLabel = SKLabelNode(fontNamed: "American Typewriter Bold")
    var gameTimer: Timer!
    var gameTime = 20.0
    // Start countdown
    let startTimerLable = SKLabelNode(fontNamed: "American Typewriter Bold")
    var startCountDown: Timer!
    var startTime = 3
    var istimerAnimationOn: Bool = false
    // End game
    var gameEnded = false
    var finalScore = 0
    // Game score menu
    var gameScore: SKLabelNode!
    var score: Float = 0 {
        didSet {
            gameScore.text = "Score: \(Int(score))"
        }
    }
    
    override func sceneDidLoad() {
    }
    
    override func didMove(to view: SKView) {
        setUpBackgrounds()
        startTimer()
    }
    
    func touchDown(atPoint pos : CGPoint) {
        //        if let n = self.spinnyNode?.copy() as! SKShapeNode? {
        //            n.position = pos
        //            n.strokeColor = SKColor.green
        //            self.addChild(n)
        //        }
    }
    
    func touchMoved(toPoint pos : CGPoint) {
        //        if let n = self.spinnyNode?.copy() as! SKShapeNode? {
        //            n.position = pos
        //            n.strokeColor = SKColor.blue
        //            self.addChild(n)
        //        }
    }
    
    func touchUp(atPoint pos : CGPoint) {
        //        if let n = self.spinnyNode?.copy() as! SKShapeNode? {
        //            n.position = pos
        //            n.strokeColor = SKColor.red
        //            self.addChild(n)
        //        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        //        if let label = self.label {
        //            label.run(SKAction.init(named: "Pulse")!, withKey: "fadeInOut")
        //        }
        //
        //        for t in touches { self.touchDown(atPoint: t.location(in: self)) }
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
    
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
        if lastUpdateTimeInterval == 0 {
            lastUpdateTimeInterval = currentTime
        }
        
        deltaTime = currentTime - lastUpdateTimeInterval
        lastUpdateTimeInterval = currentTime
        
        updateBackground()
    }
    
    func setUpBackgrounds() {
        //add background
        
        for i in 0...7 {
            
            let background = SKSpriteNode(imageNamed: "\(i).png")
            background.anchorPoint = CGPoint(x: 0, y: 0)
            background.position = CGPoint(x: CGFloat(i) * size.width, y: 0)
            background.size = CGSize(width: self.size.width, height: self.size.height)
            background.zPosition = -1
            background.name = "Background"
            self.addChild(background)
            
        }
        
        let world = SKSpriteNode(imageNamed: "world")
        world.anchorPoint = CGPoint(x: 0, y: 0)
        world.position = CGPoint(x: 25, y: size.height / 4)
        world.zPosition = 1
        world.alpha = 0.3
        world.name = "world"
        self.addChild(world)
        
        let blackOverlay = SKSpriteNode(imageNamed: "black-gradient")
        blackOverlay.anchorPoint = CGPoint(x: 0, y: 0)
        blackOverlay.position = CGPoint(x: 0, y: 0)
        blackOverlay.zPosition = 1
        blackOverlay.name = "world"
        self.addChild(blackOverlay)
    }
    
    func updateBackground() {
        self.enumerateChildNodes(withName: "Background") { (node, stop) in
            
            if let back = node as? SKSpriteNode {
                let move = CGPoint(x: -self.backgroundSpeed * CGFloat(self.deltaTime), y: 0)
                back.position += move
                
                if back.position.x < -back.size.width {
                    back.position += CGPoint(x: back.size.width * CGFloat(8), y: 0)
                }
            }
            
        }
    }
    
    // Build score label
    func createScore() {
        gameScore = SKLabelNode(fontNamed: "American Typewriter Bold")
        gameScore.text = "Score: 0"
        gameScore.horizontalAlignmentMode = .left
        gameScore.verticalAlignmentMode = .top
        gameScore.fontSize = 48
        addChild(gameScore)
        gameScore.position = CGPoint(x: viewWidth - 250, y: viewHeight-20)
    }
    
    // Build timer label
    func createTimer() {
        clockLabel.text = "Time: \(timeString(time: TimeInterval(gameTime)))"
        clockLabel.horizontalAlignmentMode = .left
        clockLabel.verticalAlignmentMode = .top
        clockLabel.fontSize = 48
        clockLabel.zPosition = 2
        addChild(clockLabel)
        clockLabel.position = CGPoint(x: 20, y: viewHeight-20)
    }
    
    // Run the game timer
    func runTimer() {
        gameTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: (#selector(updateTimer)), userInfo: nil, repeats: true)
    }
    
    // Formate timer string if time is more than 60 seconds
    func timeString(time:TimeInterval) -> String {
        let minutes = Int(time) / 60 % 60
        let seconds = Int(time) % 60
        return String(format:"%i:%02i", minutes, seconds)
    }
    
    // Update the game timer iver seconed. If time is up stop game
    @objc func updateTimer()  {
        if gameTime < 1 {
            //Send alert to indicate time's up.
            gameTimer.invalidate()
//            startTime = 3
            // Move the clock to centre of screen
            clockLabel.horizontalAlignmentMode = .center
            clockLabel.verticalAlignmentMode = .center
            clockLabel.position = CGPoint(x: viewWidth/2, y: viewHeight/2)
            clockLabel.text = "Times Up!"
            // Move the score to centre of screen
            gameScore.horizontalAlignmentMode = .center
            gameScore.verticalAlignmentMode = .center
            gameScore.fontSize = 80
            gameScore.position = CGPoint(x: viewWidth/2, y: Int(Float(viewHeight)/1.5))
            viewController.leftView.isHidden = true
            viewController.rightView.isHidden = true
            //  End game
            gameEnded = true
            // Go to menu
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) { [unowned self] in
                self.clockLabel.removeAllActions()
                self.clockLabel.fontColor = UIColor.white
                self.gameScore.removeFromParent()
                self.score = 0.0
                self.clockLabel.removeFromParent()
                self.gameSceneDelegate?.gameOver()
            }
        } else {
            gameTime -= 1
            //  Formate timer label
            if gameTime >= 60.0 {
                clockLabel.text = "Time: \(timeString(time: TimeInterval(Int(gameTime))))"
            } else {
                clockLabel.text = "Time: \(Int(gameTime))"
            }
            // Animate the clock label when time is running out
            if gameTime <= 10.0 {
                clockLabel.fontColor = UIColor.red
                animateNode(clockLabel)
                istimerAnimationOn = true
            } else if istimerAnimationOn && gameTime > 10.0 {
                //  Disable animation - this is only used when time is added to the game timer for score multiplier
                clockLabel.removeAllActions()
            }
        }
    }
    
    //  Animate nodes reference: https://www.swiftbysundell.com/posts/using-spritekit-to-create-animations-in-swift
    func animateNode(_ node: SKNode) {
        node.run(.sequence([
            .repeatForever(.sequence([
                .scale(to: 1.5, duration: 0.3),
                .wait(forDuration: TimeInterval(0.2)),
                .scale(to: 1, duration: 0.3),
                .wait(forDuration: 0.2)
                ]))
            ]))
    }
    
    // Build game starting countdown timer
    func startTimer() {
        startTimerLable.text = "3"
        startTimerLable.horizontalAlignmentMode = .center
        startTimerLable.verticalAlignmentMode = .center
        startTimerLable.position = CGPoint(x: viewWidth/2, y: viewHeight/2)
        startTimerLable.fontSize = 120
        startTimerLable.zPosition = 2
        addChild(startTimerLable)
        animateNode(startTimerLable)
        startCountDown = Timer.scheduledTimer(timeInterval: 1, target: self, selector: (#selector(updateStartTimer)), userInfo: nil, repeats: true)
    }
    
    // Initiate and start game
    @objc func updateStartTimer() {
        if startTime == 1 {
            resetGame()
//            if gameKitEnabled {
//                createTopScore()
//            }
            createScore()
            createTimer()
            startCountDown.invalidate()
            startTimerLable.removeFromParent()
            startTimerLable.removeAllActions()
            viewController.leftView.isHidden = false
            viewController.rightView.isHidden = false
            viewController.startGame()
            runTimer()
        } else {
            startTime -= 1
            startTimerLable.text = "\(startTime)"
        }
        
    }
    
    func incrementScore(_ score: Float) {
        gameScore.text = "Score: \(String(Int(score)))"
        run(SKAction.playSoundFileNamed("right.caf", waitForCompletion: false))
    }
    
    func resetGame()  {
        gameEnded = false
        finalScore = 0        
    }
    
}
