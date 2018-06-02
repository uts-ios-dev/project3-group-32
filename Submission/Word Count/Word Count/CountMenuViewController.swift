//
//  CountMenuViewController.swift
//  Word Count
//
//  Created by Clint Sellen on 2/6/18.
//  Copyright © 2018 UTS. All rights reserved.
//

import UIKit

class CountMenuViewController: UIViewController {

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
//        guard let sender = sender as? UIButton else {return}
        
//        segue.destination.navigationController?.setNavigationBarHidden(false, animated: false)
//        self.navigationController?.setNavigationBarHidden(false, animated: false)
//        if sender == forgotPasswordButton {
//            segue.destination.navigationItem.title = "Forgot Password"
//        } else if sender == forgotUsernameButton {
//            segue.destination.navigationItem.title = "Forgot Username"
//        } else {
//            segue.destination.navigationItem.title = userNameTextField.text
//        }
        
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
