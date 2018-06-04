//
//  WordMenuViewController.swift
//  Word Count
//
//  Created by Clint Sellen on 2/6/18.
//  Copyright © 2018 UTS. All rights reserved.
//

import UIKit
import Firebase
import FirebaseFirestore

class WordMenuViewController: UIViewController {
    
    var wordGameController: WordGameViewController!
    var wordMainController: MainMenuViewController!
    var jumbledWords = [String]()
    var docRef: DocumentReference!
//    var db: Firestore!
    
    @IBOutlet weak var jumbledButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        docRef = Firestore.firestore().document("WordLists/3bNsOHfU2HJhmtsXHPfo")
        
        docRef.getDocument { (docSnapshot, error) in
            guard let docSnapshot = docSnapshot, docSnapshot.exists else {return}
            let wordList = docSnapshot.data()
            self.jumbledWords = wordList!["jumbledWords"] as! [String]
            print("""
                \(self.jumbledWords)
                Word Menu View Controller
                """)
        }
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func unwindToMenu(_ sender: UIButton) {
    }
    
    @IBAction func jumbledButtonTouched(_ sender: UIButton) {
        performSegue(withIdentifier: "jumbled", sender: sender)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let sender = sender as? UIButton else {return}
        wordGameController = segue.destination as! WordGameViewController
        wordGameController.wordMainController = wordMainController
        wordGameController.wordList = jumbledWords
        if sender == jumbledButton {
            segue.destination.navigationItem.title = "Jumbled Words"
            //            gameController = segue.destination as! CountGameViewController
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
