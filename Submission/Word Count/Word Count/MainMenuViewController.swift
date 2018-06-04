//
//  MainMenuViewController.swift
//  Word Count
//
//  Created by Clint Sellen on 2/6/18.
//  Copyright © 2018 UTS. All rights reserved.
//

import UIKit
import GameKit
import Firebase
//import FirebaseMessaging
//import FirebaseFirestore

class MainMenuViewController: UIViewController, GKGameCenterControllerDelegate {
    
    var countMenuConroller: CountMenuViewController!
    var wordMenuController: WordMenuViewController!
    //  GameKit Variables
    // Check if the user has Game Center enabled
    var gcEnabled = Bool()
//    var achievements = [GKAchievement]()
//    let achievement5 = GKAchievement()
//    let achievement10 = GKAchievement()
    // Check the default leaderboardID
    var gcDefaultLeaderBoard = String()
    var gcLeaderBoardSet = [String]()
    var displayName = String()
    let localPlayer: GKLocalPlayer = GKLocalPlayer.localPlayer()
    var countScore = 0
    let WORD_LEADERBOARD_ID = "com.score.wordcount.word"
    let COUNT_LEADERBOARD_ID = "com.score.wordcount.count"
    
    @IBOutlet weak var countButton: UIButton!
    @IBOutlet weak var wordButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()   
        // Do any additional setup after loading the view, typically from a nib.
        // Call the GC authentication controller
        authenticateLocalPlayer()
        InAppPurchasesService.shared.getProducts()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Show the navigation bar on the this view controller
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }

    @IBAction func unwindToMain(unwindSegue: UIStoryboardSegue) {
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func wordButtonTouched(_ sender: UIButton) {
        performSegue(withIdentifier: "word", sender: sender)
    }
    
    @IBAction func countButtonTouched(_ sender: UIButton) {
        performSegue(withIdentifier: "count", sender: sender)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let sender = sender as? UIButton else {return}
        if sender == countButton {
            countMenuConroller = segue.destination as! CountMenuViewController
            countMenuConroller.mainController = self
        }
        if sender == wordButton {
            wordMenuController = segue.destination as! WordMenuViewController
            wordMenuController.wordMainController = self
        }
    }
    
    
    @IBAction func leaderboardButtontouched(_ sender: UIBarButtonItem) {
        let gcVC = GKGameCenterViewController()
        gcVC.gameCenterDelegate = self
        gcVC.viewState = .leaderboards
//        gcVC.leaderboardIdentifier = LEADERBOARD_ID
        present(gcVC, animated: true, completion: nil)
    }
    
//    //Not wired up but ready to implement messaging
//    @IBAction func handleLogTokenTouch(_ sender: UIButton) {
//        // [START log_fcm_reg_token]
//        let token = Messaging.messaging().fcmToken
//        print("FCM token: \(token ?? "")")
//        // [END log_fcm_reg_token]
//    }
//
//    //Not wired up but ready to implement subscribing
//    @IBAction func handleSubscribeTouch(_ sender: UIButton) {
//        // [START subscribe_topic]
//        Messaging.messaging().subscribe(toTopic: "news") { error in
//            print("Subscribed to news topic")
//        }
//        // [END subscribe_topic]
//    }
    
    // Authenticate Local Player
    func authenticateLocalPlayer() {
        localPlayer.authenticateHandler = {(ViewController, error) -> Void in
            if((ViewController) != nil) {
                self.present(ViewController!, animated: true, completion: nil)
            } else if (self.localPlayer.isAuthenticated) {
                // Player is already authenticated & logged in, load game center
                self.gcEnabled = true
                print("authenticate -> gcEnabled: true!")
                // Get the default leaderboard ID
                self.localPlayer.loadDefaultLeaderboardIdentifier(completionHandler: { (leaderboardIdentifer, error) in
                    if error != nil { print(error!)
                    } else {
                        self.gcDefaultLeaderBoard = leaderboardIdentifer!
                    }
                    print("leaderBoard: \(self.gcDefaultLeaderBoard)")
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
    
    
    func showScoreBoard(_ leaderBoardId: String) {
        // Present Leader board
        let gcVC = GKGameCenterViewController()
        gcVC.gameCenterDelegate = self
        gcVC.viewState = .leaderboards
        gcVC.leaderboardIdentifier = leaderBoardId
        present(gcVC, animated: true, completion: nil)
    }
    
////    func updateLeaderBoard(_ score: Int) {
////        //  for testing
////        print("updateLeaderBoard() score: \(score)")
////        let bestScoreInt = GKScore(leaderboardIdentifier: LEADERBOARD_ID)
////        bestScoreInt.value = Int64(score)
////        GKScore.report([bestScoreInt]) { (error) in
////            if error != nil {
////                print(error!.localizedDescription)
////            } else {
//////  for testing
////                print("Score submitted to Leaderboard")
////            }
////        }
//
//
//    }
    
    func updateWordLeaderBoard(_ score: Int) {
        //  for testing
        print("updateWordLeaderBoard() score: \(score)")
        let bestScoreInt = GKScore(leaderboardIdentifier: WORD_LEADERBOARD_ID)
        bestScoreInt.value = Int64(score)
        GKScore.report([bestScoreInt]) { (error) in
            if error != nil {
                print(error!.localizedDescription)
            } else {
                //  for testing
                print("Score submitted to Word Leaderboard")
            }
        }
    }
    
    func updateCountLeaderBoard(_ score: Int) {
        //  for testing
        print("updateCountLeaderBoard() score: \(score)")
        let bestScoreInt = GKScore(leaderboardIdentifier: COUNT_LEADERBOARD_ID)
        bestScoreInt.value = Int64(score)
        GKScore.report([bestScoreInt]) { (error) in
            if error != nil {
                print(error!.localizedDescription)
            } else {
                //  for testing
                print("Score submitted to Count Leaderboard")
            }
        }
//        var achievements = [GKAchievement]()
//        if score > -5 {
//            let achievement = GKAchievement(identifier: "70590539")
//            let achievement5 = GKAchievement(identifier: "countScore5")
        var achievements = [GKAchievement]()
        let achievement5 = GKAchievement(identifier: "countScore5")
        let achievement10 = GKAchievement(identifier: "countScore10")
        let achievement20 = GKAchievement(identifier: "countScore20")
        achievements.append(achievement5)
        achievements.append(achievement10)
        achievements.append(achievement20)
        
        if Double(score)/5 * 100.0 < 100 {
            achievement5.percentComplete = Double(score)/5 * 100.0
        } else {
            achievement5.percentComplete = 100.0
        }
        
        if Double(score)/10 * 100.0 < 100 {
            achievement10.percentComplete = Double(score)/10 * 100.0
        } else {
            achievement10.percentComplete = 100.0
        }
        
        if Double(score)/20 * 100.0 < 100 {
            achievement20.percentComplete = Double(score)/20 * 100.0
        } else {
            achievement20.percentComplete = 100.0
        }
        
        if !achievement5.isCompleted {
            GKAchievement.report([achievement5], withCompletionHandler: {(error) in
                if error != nil {
                    print(error!.localizedDescription)
                } else {
                    print("Achievement5 submitted to Achievements")
                }
            })
        }
        if !achievement10.isCompleted {
            GKAchievement.report([achievement10], withCompletionHandler: {(error) in
                if error != nil {
                    print(error!.localizedDescription)
                } else {
                    print("Achievement10 submitted to Achievements")
                }
            })
        }
        if !achievement20.isCompleted {
            GKAchievement.report([achievement20], withCompletionHandler: {(error) in
                if error != nil {
                    print(error!.localizedDescription)
                } else {
                    print("Achievement20 submitted to Achievements")
                }
            })
        }
        
//        print(achievements)
    }

}

