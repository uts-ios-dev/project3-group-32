//
//  GameScene.swift
//  animated-bg
//
//  Created by Charlie Sweeney on 21/5/18.
//  Copyright © 2018 Charlie Sweeney. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    
    let screenWidth = 1024
    let screenHeight = 750
    
    var backgroundSpeed: CGFloat = 200.0 // Speed of background
    var deltaTime: TimeInterval = 0
    var lastUpdateTimeInterval: TimeInterval = 0
    
    
    
    override func didMove(to view: SKView) {
        
        setUpBackgrounds()
        
    }
    
    
    
    override func update(_ currentTime: TimeInterval) {
        if lastUpdateTimeInterval == 0 {
            lastUpdateTimeInterval = currentTime
        }
        
        deltaTime = currentTime - lastUpdateTimeInterval
        lastUpdateTimeInterval = currentTime
        
        //MARK:- Last step:- add these methods here
        updateBackground()
//        updateWorldMovement()
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

            let world = SKSpriteNode(imageNamed: "worldx2")
            world.anchorPoint = CGPoint(x: 0, y: 0)
            world.position = CGPoint(x: 25, y: size.height / 4)
            world.zPosition = 1
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
    
}
