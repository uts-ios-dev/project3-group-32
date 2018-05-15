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
    @IBOutlet weak var twoButton: UIButton!
    @IBOutlet weak var threeButton: UIButton!
    @IBOutlet weak var fourButton: UIButton!
    @IBOutlet weak var fiveButton: UIButton!
    @IBOutlet weak var sixButton: UIButton!
    @IBOutlet weak var sevenButton: UIButton!
    @IBOutlet weak var eightButton: UIButton!
    @IBOutlet weak var nineButton: UIButton!
    @IBOutlet weak var zeroButton: UIButton!
    
    
    @IBOutlet var checkButton: UIButton!
    
    @IBOutlet weak var numeratorLabel: UILabel!
    @IBOutlet weak var denominatorLabel: UILabel!
    @IBOutlet weak var operatorLabel: UILabel!
    @IBOutlet weak var answerLabel: UILabel!
    @IBOutlet weak var gameTimerLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    
    let number = 9999999999
    var problemSize = 100
    var wrongAnswer: Bool = false
    var gameTimer: Timer!
    var gameTime: Int = 30
    var gameOver: Bool = false
    var score: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadNewProplem()
        gameTimerLabel.text = String(gameTime)
        startGameTimer()
        scoreLabel.text = String(score)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func numberButtonTouched(_ sender: UIButton) {
        if gameOver {
            return
        }
        
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
            score += 1
            gameTime += 5
            gameTimerLabel.text = String(gameTime)
            scoreLabel.text = String(score)
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
    
    func startGameTimer()  {
        gameTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateGameTimer), userInfo: nil, repeats: true)
    }
    
    @objc func updateGameTimer() {
        if gameTime < 1 {
            gameTimer.invalidate()
            gameOver = true
        } else {
            gameTime -= 1
            gameTimerLabel.text = String(gameTime)
        }
    }
    
}

