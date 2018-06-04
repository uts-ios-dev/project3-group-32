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
    
    @IBOutlet weak var jumbledButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        docRef = Firestore.firestore().document("WordLists/3bNsOHfU2HJhmtsXHPfo")
        
        docRef.getDocument { (docSnapshot, error) in
            guard let docSnapshot = docSnapshot, docSnapshot.exists else {return}
            let wordList = docSnapshot.data()
            self.jumbledWords = wordList!["jumbledWords"] as! [String]
//            print("""
//                \(self.jumbledWords)
//                Word Menu View Controller
//                """)
        }
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Show the navigation bar on the this view controller
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
// MARK: - Navigation
    
    @IBAction func unwindToMenu(_ sender: UIButton) {
    }
    
    @IBAction func jumbledButtonTouched(_ sender: UIButton) {
        if !jumbledWords.isEmpty {
            performSegue(withIdentifier: "jumbled", sender: sender)
        }
    }
    
    @IBAction func animalButtonTouched(_ sender: UIButton) {
        InAppPurchasesService.shared.purchase(product: .AnimalWordList)
    }
    
    @IBAction func scienceButtonTouched(_ sender: UIButton) {
        InAppPurchasesService.shared.purchase(product: .ScienceWordList)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let sender = sender as? UIButton else {return}
        wordGameController = segue.destination as! WordGameViewController
        wordGameController.wordMainController = wordMainController
        wordGameController.wordList = jumbledWords
        if sender == jumbledButton {
            segue.destination.navigationItem.title = "Jumbled Words"
        }
    }
    

}
