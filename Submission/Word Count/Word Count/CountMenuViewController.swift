//
//  CountMenuViewController.swift
//  Word Count
//
//  Created by Clint Sellen on 2/6/18.
//  Copyright © 2018 UTS. All rights reserved.
//

import UIKit

class CountMenuViewController: UIViewController {
    
    var gameController: CountGameViewController!
    var operation: String!
    @IBOutlet weak var additionButton: UIButton!
    @IBOutlet weak var subtractionButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func unwindToMain(_ sender: UIButton) {
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let sender = sender as? UIButton else {return}
        
        if sender == additionButton {
            segue.destination.navigationItem.title = "Addition"
            gameController = segue.destination as! CountGameViewController
            gameController.op = plus
        } else if sender == subtractionButton {
            segue.destination.navigationItem.title = "Subtraction"
            gameController = segue.destination as! CountGameViewController
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
    
    
    
    
    
}
