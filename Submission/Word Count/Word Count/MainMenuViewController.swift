//
//  MainMenuViewController.swift
//  Word Count
//
//  Created by Clint Sellen on 2/6/18.
//  Copyright © 2018 UTS. All rights reserved.
//

import UIKit
import GameKit

class MainMenuViewController: UIViewController, GKGameCenterControllerDelegate {

    //  GameKit Variables
    // Check if the user has Game Center enabled
    var gcEnabled = Bool()
    // Check the default leaderboardID
    var gcDefaultLeaderBoard = String()
    var displayName = String()
    let localPlayer: GKLocalPlayer = GKLocalPlayer.localPlayer()
    var countScore = 0
    let LEADERBOARD_ID = "com.score.wordcount"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        // Call the GC authentication controller
        authenticateLocalPlayer()
    }

    @IBAction func unwindToMain(unwindSegue: UIStoryboardSegue) {
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func leaderboardButtontouched(_ sender: UIBarButtonItem) {
        let gcVC = GKGameCenterViewController()
        gcVC.gameCenterDelegate = self
        gcVC.viewState = .leaderboards
        gcVC.leaderboardIdentifier = LEADERBOARD_ID
        present(gcVC, animated: true, completion: nil)
    }
    
    // Authenticate Local Player
    func authenticateLocalPlayer() {
        localPlayer.authenticateHandler = {(ViewController, error) -> Void in
            if((ViewController) != nil) {
                self.present(ViewController!, animated: true, completion: nil)
            } else if (self.localPlayer.isAuthenticated) {
                // Player is already authenticated & logged in, load game center
                self.gcEnabled = true
                // Get the default leaderboard ID
                self.localPlayer.loadDefaultLeaderboardIdentifier(completionHandler: { (leaderboardIdentifer, error) in
                    if error != nil { print(error!)
                    } else { self.gcDefaultLeaderBoard = leaderboardIdentifer! }
                })
                
                if self.localPlayer.displayName != nil {
                    self.displayName = self.localPlayer.displayName!
                }
            } else {
                // Game center is not enabled on the users device, no leader board or top score will be displayed
                self.gcEnabled = false
                print("Local player could not be authenticated!")
                if error != nil {
                    print(error!)
                }
            }
        }
    }
    
    // Delegate to dismiss the GC controller
    func gameCenterViewControllerDidFinish(_ gameCenterViewController: GKGameCenterViewController) {
        gameCenterViewController.dismiss(animated: true, completion: nil)
    }
    
    //  Game scene passes to this function at the end of a game
    func gameOver() {
        //  for testing
        print("Inside of gameOver()")
        // Submit score to GC leaderboard
        if gcEnabled {
            showScoreBoard()
        }
    }
    
    func showScoreBoard() {
        // Present Leader board
        let gcVC = GKGameCenterViewController()
        gcVC.gameCenterDelegate = self
        gcVC.viewState = .leaderboards
        gcVC.leaderboardIdentifier = LEADERBOARD_ID
        present(gcVC, animated: true, completion: nil)
    }

}

