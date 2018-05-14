//
//  GameSettingsViewController.swift
//  Bubble Pop
//
//  View Controller For Game Settings
//
//  Created by Melvin Philip on 1/5/18.
//  Copyright © 2018 Melvin Philip. All rights reserved.
//

import UIKit


class GameSettingsViewController: UIViewController {

    var gameTime:Int!
    var numberOfBubbles:Int!
    
    @IBOutlet weak var gameTimeLabel: UILabel!
    @IBOutlet weak var numOfBubblesLabel: UILabel!
    @IBOutlet weak var gameTimeStepperOutlet: UISlider!
    @IBOutlet weak var numOfBubblesStepperOutlet: UIStepper!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func gameTimeStepper(_ sender: UISlider) {
        gameTimeLabel.text = String(Int(sender.value))
    }
    
    @IBAction func numOfBubblesStepper(_ sender: UIStepper) {
        numOfBubblesLabel.text = String(Int(sender.value))
    }
    
    
    /*
     *  When User saves settings the settings will be saved to userDefaults
     *  to ensure settings are retained for future games.
     */
    @IBAction func saveSettings(_ sender: Any) {
        gameTime = Int(gameTimeLabel.text!)
        numberOfBubbles = Int(numOfBubblesLabel.text!)
        
        let userSettings = UserDefaults.standard
        userSettings.set(gameTime, forKey: "gameTime")
        userSettings.set(numberOfBubbles, forKey: "numberOfBubbles")
        userSettings.synchronize()
        
        let viewCont = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "viewController") as! ViewController
        self.present(viewCont, animated: false, completion: nil)
    }
    
   

    /*
     *  Using lifecycle function to ensure previously saved game settings reappear.
     */
    override func viewWillAppear(_ animated: Bool) {
        let userSettings = UserDefaults.standard
        gameTime = userSettings.integer(forKey: "gameTime")
        numberOfBubbles = userSettings.integer(forKey: "numberOfBubbles")
        
        gameTimeStepperOutlet.setValue(Float(gameTime), animated: false)
        numOfBubblesStepperOutlet.value = Double(numberOfBubbles)
        
        gameTimeLabel.text = String(Int(gameTimeStepperOutlet.value))
        numOfBubblesLabel.text = String(Int(numOfBubblesStepperOutlet.value))
    }
    
 
    

   

}
