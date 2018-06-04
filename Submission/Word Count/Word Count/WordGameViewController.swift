//
//  GameViewController.swift
//  temp
//
//  Created by Clint Sellen on 2/6/18.
//  Copyright © 2018 UTS. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit
//import Firebase
//import FirebaseFirestore

class WordGameViewController: UIViewController, WordGameSceneDelegate {
    
//    var docRef: DocumentReference!
//    var db: Firestore!
    
    var wordCurrentGame: WordGameScene!
    var wordMenuController: WordMenuViewController!
    var wordMainController: MainMenuViewController!
    
    var wordList = [String]()
    var score = 0
    var endGame: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var cnt = 0
        for _ in wordList{
            cnt += 1
        }
        
        print("Word GAME View Controller \(wordList)\rCount: \(wordList.count) -> \(cnt)")
        
        // Load 'GameScene.sks' as a GKScene. This provides gameplay related content
        // including entities and graphs.
        if let scene = GKScene(fileNamed: "WordGameScene") {
            
            // Get the SKScene from the loaded GKScene
            if let wordSceneNode = scene.rootNode as! WordGameScene? {
                // Set the scale mode to scale to fit the window
                wordSceneNode.scaleMode = .aspectFill
                
                // Present the scene
                if let view = self.view as! SKView? {
                    view.presentScene(wordSceneNode)
                    wordCurrentGame = wordSceneNode
                    wordCurrentGame.wordViewController = self
                    wordCurrentGame.wordGameSceneDelegate = self
                    
                    view.ignoresSiblingOrder = true
                    
                    view.showsFPS = true
                    view.showsNodeCount = true
                }
            }
        }
    }
    
    override var shouldAutorotate: Bool {
        return true
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    @IBAction func unwindToMain(_ sender: UIButton) {
    }
    
    
    //  Game scene passes to this function at the end of a game
    func gameOver() {
        //  for testing
        print("Inside of word gameOver()")
//        print("gcStatus -> countGameController: \(wordMainController.gcEnabled)")
//        //        Submit score to GC leaderboard
        if wordMainController.gcEnabled {
            //                mainController.updateLeaderBoard(score)
            wordMainController.updateWordLeaderBoard(score)
            wordMainController.showScoreBoard(wordMainController.WORD_LEADERBOARD_ID)
        }
        
        self.performSegue(withIdentifier: "unwindToMenu", sender: self)
        
    }
    
    func newWord() -> String {
        if wordList.count <= 0 {
            //Finished all words -> end the game
            wordCurrentGame.gameTime = 0
        }
        var word = wordList.remove(at: RandomInt(min: 0, max: wordList.count-1))
//        print(wordList.count)
        word = word.uppercased()
        return word
    }
}
