//
//  ViewController.swift
//  Bubble Pop
//
//  Created by Melvin Philip on 29/4/18.
//  Copyright © 2018 Melvin Philip. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var playerNameTextField: UITextField!
    
    let userSettings = UserDefaults.standard
    
    @IBAction func startGame(_ sender: UIButton) {
        
        //Checking if player enters a name befor starting game
        if(playerNameTextField.text?.isEmpty)!{
            let alert = UIAlertController(title: "No Name", message: "Please enter your name.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(alert, animated: false)
            return
        }
        
        
        //Setting up game screen, in order to pass user game data to view controller.
        let viewCont = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "gameScreen") as! GameScreenViewController
        
        
        //Passing default values if user has not saved a game setting.
        viewCont.playerName = playerNameTextField.text
        if(userSettings.integer(forKey: "gameTime")==0){
            viewCont.gameTime = 60
            viewCont.numberOfBubbles = 15
        } else {
            viewCont.gameTime = userSettings.integer(forKey: "gameTime")
            viewCont.numberOfBubbles = userSettings.integer(forKey: "numberOfBubbles")
        }
        
        self.present(viewCont, animated: false, completion: nil)
        
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    
}

