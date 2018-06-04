//
//  GameScene.swift
//  temp
//
//  Created by Clint Sellen on 2/6/18.
//  Copyright © 2018 UTS. All rights reserved.
//

import SpriteKit
import GameplayKit

protocol WordGameSceneDelegate {
    func gameOver()
}

class WordGameScene: SKScene {
    weak var wordViewController: WordGameViewController!
    var wordGameSceneDelegate: WordGameSceneDelegate?
    
    var viewWidth = 1024
    var viewHeight = 750
//    Animiated Background
    var backgroundSpeed: CGFloat = 200.0 // Speed of background
    var deltaTime: TimeInterval = 0
    var lastUpdateTimeInterval: TimeInterval = 0
    
    // Slice variables for touch
    var activeSlicePoints = [CGPoint]()
    var activeSliceBG: SKShapeNode!
    var activeSliceFG: SKShapeNode!
    var isSwooshSoundActive = false
    
    // Game timer menu
    let clockLabel = SKLabelNode(fontNamed: "American Typewriter Bold")
    var gameTimer: Timer!
    var gameTime = 11.0
    // Start countdown
    let startTimerLable = SKLabelNode(fontNamed: "American Typewriter Bold")
    var startCountDown: Timer!
    var startTime = 3
    var istimerAnimationOn: Bool = false
    // Word label
    var wordLabel = SKLabelNode(fontNamed: "American Typewriter Bold")
    var difficulty = 0.5
    var canTouch = false
    var endGame = false
    
    override func sceneDidLoad() {
        setUpBackgrounds()
        startTimer()
        createWordLabel()
        createSlices()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if !canTouch {
            return
        }
        
        super.touchesBegan(touches, with: event)
        
        // Clear view of existing slices
        activeSlicePoints.removeAll(keepingCapacity: true)
        
        // Read the touch location
        if let touch = touches.first {
            let location = touch.location(in: self)
            activeSlicePoints.append(location)
            
            // Draw the current slice
            redrawActiveSlice()
            
            // Clear the node tree of slices actions
            activeSliceBG.removeAllActions()
            activeSliceFG.removeAllActions()
            
            // Make the slice visible
            activeSliceBG.alpha = 1
            activeSliceFG.alpha = 1
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        // Disable if game is over
        if endGame || !canTouch{
            return
        }
        // Read touch action
        guard let touch = touches.first else { return }
        // Set location of touch
        let location = touch.location(in: self)
        // Draw the slice
        activeSlicePoints.append(location)
        redrawActiveSlice()
        // Make slice sounds
//        if !isSwooshSoundActive {
//            playSwooshSound()
//        }
        // Detect interesction of touch and bubble
        let nodesAtPoint = nodes(at: location)
        for node in nodesAtPoint {
            
//            // If bubble is touched then pop it
//            if node.name == "bubbleRed" || node.name == "bubblePink" || node.name == "bubbleGreen" || node.name == "bubbleBlue" || node.name == "bubbleBlack" {
//                let nodeName = node.name!
//
//                // Fire the coloured explosion animation on bubble popped
//                let emitter = SKEmitterNode(fileNamed: "\(nodeName)SliceHit")!
//                emitter.position = node.position
//                addChild(emitter)
//
//                //  Check if consecutive colours were popped, apply score multiplier and show label if true
//                if lastPoppedName == nodeName {
//                    //  Add a bonus time to game timer for a same bubble popped sequence
//                    gameTime += 0.5
//                    pointsMultiplier = 1.5
//                    multiplierLabel.alpha = 0.8
//                    animateNode(multiplierLabel)
//                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [unowned self] in
//                        self.multiplierLabel.alpha = 0
//                    }
//                } else {
//                    pointsMultiplier = 1.0
//                }
//                // For testing
//                //              print("Last Bubble: \(lastPoppedName) nodeName: \(nodeName) \(pointsMultiplier)")
//                //  Clear bubble from view
//                lastPoppedName = nodeName
//                node.name = ""
//                lastBubbblePopImage.removeFromParent()
//                // Prohibit physics interactions
//                node.physicsBody?.isDynamic = false
//                // Animate bubble removal
//                let scaleOut = SKAction.scale(to: 0.001, duration:0.2)
//                let fadeOut = SKAction.fadeOut(withDuration: 0.2)
//                let group = SKAction.group([scaleOut, fadeOut])
//                //  Run animation
//                let seq = SKAction.sequence([group, SKAction.removeFromParent()])
//                node.run(seq)
//                // Add score and set last bubble popped label
//                let oldScore = score
//                switch nodeName {
//                case "bubbleRed":
//                    score += 1 * pointsMultiplier
//                    createlastBubblePop(imageName: "ballRed")
//                case "bubblePink":
//                    score += 2 * pointsMultiplier
//                    createlastBubblePop(imageName: "ballPink")
//                case "bubbleGreen":
//                    score += 5 * pointsMultiplier
//                    createlastBubblePop(imageName: "ballGreen")
//                case "bubbleBlue":
//                    score += 8 * pointsMultiplier
//                    createlastBubblePop(imageName: "ballCyan")
//                case "bubbleBlack":
//                    score += 10 * pointsMultiplier
//                    createlastBubblePop(imageName: "ballBlack")
//                default:
//                    score += 0
//                    createlastBubblePop(imageName: "sliceLife")
//                }
//
//                addToScoreLabel.text = "+\(Int(score - oldScore))"
//                addToScoreLabel.alpha = 0.8
//                animateNode(addToScoreLabel)
//                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [unowned self] in
//                    self.addToScoreLabel.alpha = 0
//                }
//                // Remove bubble from active bubble array
//                let index = activeBubbles.index(of: node as! SKSpriteNode)!
//                activeBubbles.remove(at: index)
//                // Play bubble popped sound effect
//                run(SKAction.playSoundFileNamed("whack.caf", waitForCompletion: false))
//            }
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        if !canTouch {
            return
        }
        //  Animate slice disappearing
        activeSliceBG.run(SKAction.fadeOut(withDuration: 0.20))
        activeSliceFG.run(SKAction.fadeOut(withDuration: 0.15))
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        //  Trigger slice disappearing animation
        touchesEnded(touches, with: event)
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
    
    func createWordLabel() {
        wordLabel.horizontalAlignmentMode = .center
        wordLabel.verticalAlignmentMode = .bottom
        wordLabel.fontSize = 48
        wordLabel.zPosition = 2
        wordLabel.text = "_ _ _ _ _"
        addChild(wordLabel)
        wordLabel.position = CGPoint(x: viewWidth/2, y: 40)
    }
    
    // Build timer label
    func createTimer() {
        clockLabel.text = "Time: \(timeString(time: TimeInterval(gameTime)))"
        clockLabel.horizontalAlignmentMode = .left
        clockLabel.verticalAlignmentMode = .top
        clockLabel.fontSize = 48
        clockLabel.zPosition = 2
        addChild(clockLabel)
        clockLabel.position = CGPoint(x: 20, y: viewHeight-50)
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
        if gameTime < 1 || endGame {
            //Send alert to indicate time's up.
            gameTimer.invalidate()
            //            startTime = 3
            // Move the clock to centre of screen
            clockLabel.horizontalAlignmentMode = .center
            clockLabel.verticalAlignmentMode = .center
            clockLabel.position = CGPoint(x: viewWidth/2, y: viewHeight/2)
            clockLabel.text = "Times Up!"
            // Move the score to centre of screen
//            gameScore.horizontalAlignmentMode = .center
//            gameScore.verticalAlignmentMode = .center
//            gameScore.fontSize = 80
//            gameScore.position = CGPoint(x: viewWidth/2, y: Int(Float(viewHeight)/1.5))
            //  Clear last bubble popped menu
            //            if gameKitEnabled {
            //                viewController.updateLeaderBoard(Int(score))
            //            }
//            viewController.leftView.isHidden = true
//            viewController.rightView.isHidden = true
            //  End game
//            gameEnded = true
            // Go to menu
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) { [unowned self] in
                //                if self.gameKitEnabled {
                //                    self.topScoreLabel.removeFromParent()
                //                    self.topScoreLabel.removeAllActions()
                //                }
                self.clockLabel.removeAllActions()
                self.clockLabel.fontColor = UIColor.white
//                self.gameScore.removeFromParent()
//                self.score = 0.0
                self.clockLabel.removeFromParent()
                self.wordGameSceneDelegate?.gameOver()
            }
        } else {
            gameTime -= 1
            updateWordLabel(wordViewController.newWord())
//            wordLabel.text = wordViewController.newWord()
            
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
            //  Animate top score label if top score is achieved
            //            if gameKitEnabled && Int(score) > topScore {
            //                topScoreLabel.text = "New Top Score: \(Int(score))"
            //                animateNode(topScoreLabel)
            //            }
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
//            resetGame()
            //            if gameKitEnabled {
            //                createTopScore()
            //            }
//            createScore()
            createTimer()
            startCountDown.invalidate()
            startTimerLable.removeFromParent()
            startTimerLable.removeAllActions()
//            viewController.leftView.isHidden = false
//            viewController.rightView.isHidden = false
//            viewController.startGame()
            canTouch = true
            runTimer()
        } else {
            startTime -= 1
            startTimerLable.text = "\(startTime)"
        }
    }
    
    // Create slices
    func createSlices() {
        activeSliceBG = SKShapeNode()
        activeSliceBG.zPosition = 2
        
        activeSliceFG = SKShapeNode()
        activeSliceFG.zPosition = 2
        
        activeSliceBG.strokeColor = UIColor.yellow
        activeSliceBG.lineWidth = 10
        
        activeSliceFG.strokeColor = UIColor.white
        activeSliceFG.lineWidth = 5
        
        addChild(activeSliceBG)
        addChild(activeSliceFG)
    }
    
    //  Draw slices
    func redrawActiveSlice() {
        if activeSlicePoints.count < 2 {
            activeSliceBG.path = nil
            activeSliceFG.path = nil
            return
        }
        
        while activeSlicePoints.count > 6 {
            activeSlicePoints.remove(at: 0)
        }
        
        let path = UIBezierPath()
        path.move(to: activeSlicePoints[0])
        
        for i in 1 ..< activeSlicePoints.count {
            path.addLine(to: activeSlicePoints[i])
        }
        
        activeSliceBG.path = path.cgPath
        activeSliceFG.path = path.cgPath
    }
    

    
    func updateWordLabel(_ word: String) {
        var newWordLabelText = ""
        var bubbleCharacters = [Character]()
        let numChar = Int(Double(word.count)*difficulty)
        var i = 0
        var j = 0
        var tmpContainer = [Int]()
        while i < numChar {
            let num = RandomInt(min: 0, max: numChar)
            if !tmpContainer.contains(num){
                tmpContainer.append(num)
                i += 1
            }
        }
        
        for w in word {
            if tmpContainer.contains(j) {
                newWordLabelText = "\(newWordLabelText) \(w)"
            } else {
                bubbleCharacters.append(w)
                newWordLabelText = "\(newWordLabelText) _"
            }
            j += 1
        }
        print("Bubble Character: \(bubbleCharacters)")
        print("Word Label: \(newWordLabelText)")
        wordLabel.text = newWordLabelText
    }



}
