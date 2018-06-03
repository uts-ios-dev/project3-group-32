//
//  CountMenuViewController.swift
//  Word Count
//
//  Created by Clint Sellen on 2/6/18.
//  Copyright © 2018 UTS. All rights reserved.
//

import UIKit
import GameKit

class CountMenuViewController: UIViewController {
    
    var gameController: CountGameViewController!
    var mainController: MainMenuViewController!
    var operation: String!
    @IBOutlet weak var additionButton: UIButton!
    @IBOutlet weak var subtractionButton: UIButton!
    
    var gcEnabled = Bool()
    var gcLeaderBoard = String()
//    var displayName = String()
//    let localPlayer: GKLocalPlayer = GKLocalPlayer.localPlayer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        print("count menu controller: gcEnabled \(gcEnabled) leaderboard \(gcLeaderBoard)")
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func unwindToMenu(_ sender: UIButton) {
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let sender = sender as? UIButton else {return}
        gameController = segue.destination as! CountGameViewController
        gameController.mainController = mainController
        if sender == additionButton {
            segue.destination.navigationItem.title = "Addition"
//            gameController = segue.destination as! CountGameViewController
            gameController.op = plus
        } else if sender == subtractionButton {
            segue.destination.navigationItem.title = "Subtraction"
//            gameController = segue.destination as! CountGameViewController
            gameController.op = minus
        }
    }
    

    @IBAction func plusButtinTouched(_ sender: UIButton) {
        operation = plus
        performSegue(withIdentifier: "plus", sender: sender)
    }
    
    @IBAction func minusButtonPressed(_ sender: UIButton) {
        operation = minus
        performSegue(withIdentifier: "minus", sender: sender)
    }
    
    
//    func updateLeaderBoard(_ score: Int) {
//        //  for testing
//                print("updateLeaderBoard() score: \(score)")
//        let scoreInt = GKScore(leaderboardIdentifier: gcLeaderBoard)
//        scoreInt.value = Int64(score)
//        GKScore.report([scoreInt]) { (error) in
//            if error != nil {
//                print(error!.localizedDescription)
//            } else {
//                //  for testing
//                //                print("Best Score submitted to your Leaderboard!")
//            }
//        }
//    }
    
    
}
