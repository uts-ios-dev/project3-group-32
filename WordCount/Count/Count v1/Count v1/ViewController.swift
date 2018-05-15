//
//  ViewController.swift
//  Count v1
//
//  Created by Clint Sellen on 15/5/18.
//  Copyright © 2018 UTS. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet var oneButton: UIButton!
    @IBOutlet var twoButton: UIButton!
    @IBOutlet var threeButton: UIButton!
    @IBOutlet var fourButton: UIButton!
    @IBOutlet var fiveButton: UIButton!
    @IBOutlet var sixButton: UIButton!
    @IBOutlet var sevenButton: UIButton!
    @IBOutlet var eightButton: UIButton!
    @IBOutlet var nineButton: UIButton!
    @IBOutlet var zeroButton: UIButton!
    
    @IBOutlet var checkButton: UIButton!
    
    @IBOutlet weak var numeratorLabel: UILabel!
    @IBOutlet weak var denominatorLabel: UILabel!
    @IBOutlet weak var operatorLabel: UILabel!
    @IBOutlet weak var answerLabel: UILabel!
    
    let number = 9999999999
    var problemSize = 100
    var wrongAnswer: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadNewProplem()
//        numeratorLabel.text = "123"
//        operatorLabel.text = "+"
//        denominatorLabel.text = "12"
//        answerLabel.text = ""
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    @IBAction func numberButtonTouched(_ sender: UIButton) {
        if wrongAnswer {
            wrongAnswer = false
            answerLabel.text = ""
            answerLabel.textColor = UIColor.black
        }
        
        switch sender {
        case oneButton:
            numberTouchedAction(number: 1)
        case twoButton:
            numberTouchedAction(number: 2)
        case threeButton:
            numberTouchedAction(number: 3)
        case fourButton:
            numberTouchedAction(number: 4)
        case fiveButton:
            numberTouchedAction(number: 5)
        case sixButton:
            numberTouchedAction(number: 6)
        case sevenButton:
            numberTouchedAction(number: 7)
        case eightButton:
            numberTouchedAction(number: 8)
        case nineButton:
            numberTouchedAction(number: 9)
        case zeroButton:
            numberTouchedAction(number: 0)
        case checkButton:
            print("Answer")
            calculate()
        default:
            print("Clear")
            answerLabel.text = ""
        }
    }
    
    @IBAction func checkButtonTouched(_ sender: UIButton) {
    }
    
    func numberTouchedAction(number: Int){
        if let currentLabel = answerLabel.text {
            answerLabel.text = "\(currentLabel)\(String(number))"
        }
    }
    
    func calculate() {
        guard let numerator = numeratorLabel.text, let op = operatorLabel.text, let denominator = denominatorLabel.text, let answer = answerLabel.text else { return }
        
        let equation = "\(numerator) \(op) \(denominator)"
        
        let result = ShuntingYard.parse(equation, operators: operators)
        
        print("Result: \(result)")
        
        if result == Int(answer) {
            loadNewProplem()
        } else {
            answerLabel.textColor = UIColor.red
            wrongAnswer = true
        }
    }
    
    func loadNewProplem() {
        answerLabel.textColor = UIColor.black
        let num1 = RandomInt(min: number % (problemSize/10), max: number % problemSize)
        let num2 = RandomInt(min: number % (problemSize/10), max: number % problemSize)
        
        if num1 > num2 {
            numeratorLabel.text = String(num1)
            denominatorLabel.text = String(num2)
        } else {
            numeratorLabel.text = String(num2)
            denominatorLabel.text = String(num1)
        }
        
        operatorLabel.text = plus
        answerLabel.text = ""
    }
    
}

