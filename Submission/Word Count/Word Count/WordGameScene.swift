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

// Type of bubble launches
enum SequenceType: Int {
    case one, halfMax, max, chain, fastChain
}

class WordGameScene: SKScene {
    weak var wordViewController: WordGameViewController!
    var wordGameSceneDelegate: WordGameSceneDelegate?
    var viewWidth = 1024
    var viewHeight = 750
    var gravity = CGVector(dx: 0.0, dy: -0.01)
//    Animiated Background
    var backgroundSpeed: CGFloat = 200.0 // Speed of background
    var deltaTime: TimeInterval = 0
    var lastUpdateTimeInterval: TimeInterval = 0
    // Slice variables for touch
    var activeSlicePoints = [CGPoint]()
    var activeSliceBG: SKShapeNode!
    var activeSliceFG: SKShapeNode!
    var isSwooshSoundActive = false
    // Bubble parameters
    var activeBubbles = [SKSpriteNode]()
    var currentWord = ""
    var newWordLabelText = ""
    var bubbleCharacters = [Character]()
    var bogusCharacters = [Character]()
    // Game timer menu
    let clockLabel = SKLabelNode(fontNamed: "American Typewriter Bold")
    var gameTimer: Timer!
    var gameTime = 30.0
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
    var addToScoreLabel: SKLabelNode!
    // Game score menu
    var gameScore: SKLabelNode!
    var score: Float = 0 {
        didSet {
            gameScore.text = "Score: \(Int(score))"
        }
    }
    
    override func sceneDidLoad() {
        setUpBackgrounds()
        startTimer()
        createWordLabel()
        createSlices()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if !canTouch { return }
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
        // Detect interesction of touch and bubble
        let nodesAtPoint = nodes(at: location)
        for node in nodesAtPoint {
            guard let nodeName = node.name else { return }
            print(nodeName)
            if !nodeName.isEmpty && bogusCharacters.contains(Character(nodeName)) {
                print("BANG FAKETIME")
                gameTime -= 2
                // Play bubble popped sound effect
                run(SKAction.playSoundFileNamed("wrong.caf", waitForCompletion: false))
//                     Remove bubble from active bubble array
                let index = activeBubbles.index(of: node as! SKSpriteNode)!
                activeBubbles.remove(at: index)
            }
            if !nodeName.isEmpty && bubbleCharacters.contains(Character(nodeName)) {
                newWordLabelText = ""
                var updateLabel = wordLabel.text!.filter({ $0 != " " }).compactMap({$0})
                var currentWordArray = currentWord.compactMap({$0})
                print("Update Label: \(updateLabel), Current Word Array \(currentWordArray)")
                
                for index in 0..<currentWordArray.count {
                    if currentWordArray[index] == Character(nodeName) && updateLabel[index] == "_" {
                        updateLabel[index] = currentWordArray[index]
                    }
                }
                
                print("Update Label: \(updateLabel)")
                for char in updateLabel {
                    newWordLabelText = "\(newWordLabelText) \(char)"
                }
                
                if updateLabel == currentWordArray {
                    print("COMPLETED!!")
                    wordLabel.text = newWordLabelText
                    gameTime += 10
                    addToScoreAnimation(currentWord)
                    run(SKAction.playSoundFileNamed("right.caf", waitForCompletion: false))
                    cleanBubbles()
                    activeBubbles.removeAll()
                    score += 1
                } else {
                    wordLabel.text = newWordLabelText
                    // Remove bubble from active bubble array
                    let index = activeBubbles.index(of: node as! SKSpriteNode)!
                    activeBubbles.remove(at: index)
                    run(SKAction.playSoundFileNamed("right.caf", waitForCompletion: false))
                }
            }
            node.name = ""
            // Prohibit physics interactions
            node.physicsBody?.isDynamic = false
            // Animate bubble removal
            let scaleOut = SKAction.scale(to: 0.001, duration:0.2)
            let fadeOut = SKAction.fadeOut(withDuration: 0.2)
            let group = SKAction.group([scaleOut, fadeOut])
            //  Run animation
            let seq = SKAction.sequence([group, SKAction.removeFromParent()])
            node.run(seq)
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
        
        if activeBubbles.count > 0 {
            for node in activeBubbles {
                //  Remove bubbles that are off the bottom of the screen from the node tree or popped
                if node.position.y < 0 {
                    node.removeAllActions()
                    node.removeFromParent()
                    if let index = activeBubbles.index(of: node) {
                        activeBubbles.remove(at: index)
                    }
                }
            }
        } else {
            if canTouch {
                updateWordLabel(wordViewController.newWord())
            }
        }
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
        gameScore.horizontalAlignmentMode = .right
        gameScore.verticalAlignmentMode = .top
        gameScore.fontSize = 48
        addChild(gameScore)
        gameScore.position = CGPoint(x: viewWidth - 20, y: viewHeight-50)
    }
    
    func createWordLabel() {
        wordLabel.horizontalAlignmentMode = .center
        wordLabel.verticalAlignmentMode = .bottom
        wordLabel.fontSize = 48
        wordLabel.zPosition = 2
        wordLabel.text = "_ _ _ _ _"
        addChild(wordLabel)
        wordLabel.position = CGPoint(x: viewWidth/2, y: 40)
        
        addToScoreLabel = SKLabelNode(fontNamed: "American Typewriter Bold")
        addToScoreLabel.horizontalAlignmentMode = .center
        addToScoreLabel.verticalAlignmentMode = .center
        addToScoreLabel.position = CGPoint(x: viewWidth/2, y: viewHeight/2)
        addToScoreLabel.fontSize = 100
        addToScoreLabel.alpha = 0
        addToScoreLabel.zPosition = 1
        addChild(addToScoreLabel)
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
    
    // Update the game timer
    @objc func updateTimer()  {
        if gameTime < 1 || endGame {
            //Send alert to indicate time's up.
            gameTimer.invalidate()
            //            startTime = 3
            // Move the clock to centre of screen
            cleanBubbles()
            canTouch = false
            wordViewController.score = Int(score)
            clockLabel.horizontalAlignmentMode = .center
            clockLabel.verticalAlignmentMode = .center
            clockLabel.position = CGPoint(x: viewWidth/2, y: viewHeight/2)
            clockLabel.text = "Times Up!"
            // Move the score to centre of screen
            gameScore.horizontalAlignmentMode = .center
            gameScore.verticalAlignmentMode = .center
            gameScore.fontSize = 80
            gameScore.position = CGPoint(x: viewWidth/2, y: Int(Float(viewHeight)/1.5))
            //  End game
            endGame = true
            // Go to menu
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) { [unowned self] in
                self.clockLabel.removeAllActions()
                self.clockLabel.fontColor = UIColor.white
                self.gameScore.removeFromParent()
                self.gameScore.removeAllActions()
                self.wordLabel.removeFromParent()
                self.score = 0.0
                self.clockLabel.removeFromParent()
                self.wordGameSceneDelegate?.gameOver()
            }
        } else {
            gameTime -= 1
//            For testing
//            updateWordLabel(wordViewController.newWord())
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
    
    func addToScoreAnimation(_ word: String){
        addToScoreLabel.text = word
        addToScoreLabel.alpha = 0.8
        animateNode(addToScoreLabel)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [unowned self] in
            self.addToScoreLabel.alpha = 0
        }
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
            createScore()
            createTimer()
            startCountDown.invalidate()
            startTimerLable.removeFromParent()
            startTimerLable.removeAllActions()
            canTouch = true
            updateWordLabel(wordViewController.newWord())
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
        if endGame { return }
        print(word)
        currentWord = word
        bubbleCharacters.removeAll()
        bogusCharacters.removeAll()
        var alphabet: [Character] = ["A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T","U","V","W","X","Y","Z"]
        newWordLabelText = ""
        let numChar = Int(Double(word.count)*difficulty)
        let numBogusChar = Int(Double(word.count)*(1-difficulty))
        var i = 0
        var num = 0
        var tmpContainer = [Int]()
        while i < numChar {
            num = RandomInt(min: 0, max: numChar)
            if !tmpContainer.contains(num){
                tmpContainer.append(num)
                i += 1
            }
        }
        i = 0
        for w in word {
            if tmpContainer.contains(i) {
                newWordLabelText = "\(newWordLabelText) \(w)"
            } else {
                if !bubbleCharacters.contains(w) {
                    bubbleCharacters.append(w)
                }
                newWordLabelText = "\(newWordLabelText) _"
            }
            i += 1
        }
        i = 0
        while i < numBogusChar {
            num = RandomInt(min: 0, max: alphabet.count-1)
            if !word.contains(alphabet[num]){
                bogusCharacters.append(alphabet[num])
                i += 1
            }
        }
        
        print("Bubble Character: \(bubbleCharacters)")
        print("Bogus Character: \(bogusCharacters)")
        createBubbles(bubbleCharacters)
        createBubbles(bogusCharacters)
        print("Word Label: \(newWordLabelText)")
        wordLabel.text = newWordLabelText
    }
    
    func cleanBubbles() {
        for b in activeBubbles {
            b.name = ""
            // Prohibit physics interactions
            b.physicsBody?.isDynamic = false
            // Animate bubble removal
            let scaleOut = SKAction.scale(to: 0.001, duration:0.2)
            let fadeOut = SKAction.fadeOut(withDuration: 0.2)
            let group = SKAction.group([scaleOut, fadeOut])
            //  Run animation
            let seq = SKAction.sequence([group, SKAction.removeFromParent()])
            b.run(seq)
        }
        
        activeBubbles.removeAll()
    }
    
    func createBubbles(_ characters: [Character]) {
        var bubble: SKSpriteNode
        var label: SKLabelNode
        for char in characters {
            bubble = SKSpriteNode(imageNamed: "wordBubble")
            bubble.name = String(char)
            bubble.zPosition = 5
//            for testing
//            print("Assigned Bubble Name: \(bubble.name!)")
            label = SKLabelNode(fontNamed: "American Typewriter Bold")
            label.text = String(char)
            label.fontSize = 60
            label.horizontalAlignmentMode = .center
            label.verticalAlignmentMode = .center
            
            bubble.addChild(label)
            addChild(bubble)
            activeBubbles.append(bubble)
            
            //Randomise Bubble Starting Position
            let randomPosition = CGPoint(x: RandomInt(min: 250, max: viewWidth - 300), y: viewHeight-100)
            bubble.position = randomPosition

            // Randomise Bubble Angular Velocity
            let randomAngularVelocity = CGFloat(RandomInt(min: -10, max: 10)) / 2.0

            //Randomise Bubble X Velocity (Horizontal)
            let randomXVelocity = RandomDouble(min: -7, max: 7)

            //Randomise Bubble Y Velocity (Verticle)
            let randomYVelocity = RandomDouble(min: 0.1, max: 1.0)

            // Apply physics
            bubble.physicsBody = SKPhysicsBody(circleOfRadius: bubble.size.width / 2.0)
            bubble.physicsBody?.velocity = CGVector(dx: randomXVelocity * 40, dy: randomYVelocity * 40)
            bubble.physicsBody?.angularVelocity = randomAngularVelocity
            physicsBody = SKPhysicsBody(edgeLoopFrom: CGRect(x: 0, y: -300, width: viewWidth, height: viewHeight+300))
            bubble.physicsBody?.restitution = 0.2
            physicsWorld.speed = 0.05
        }
    }

}
