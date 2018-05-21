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
    @IBOutlet weak var hintButton: UIButton!
    @IBOutlet weak var clearButton: UIButton!
    
    @IBOutlet weak var numeratorLabel: UILabel!
    @IBOutlet weak var denominatorLabel: UILabel!
    @IBOutlet weak var operatorLabel: UILabel!
    @IBOutlet weak var answerLabel: UILabel!
    @IBOutlet weak var gameTimerLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var hintLabel: UILabel!
    
    var result: Int = 0
    var equation: String = ""
    var op: String = plus
    let number = 9999999999
    var numeratorProblemSize = 100
    var denominatorProblemSize = 100
    var wrongAnswer: Bool = false
    var gameTimer: Timer!
    var gameTime: Int = 30
    var gameTimeBonus = 1
    var gameOver: Bool = false
    var score: Int = 0
    var flag: Bool = true
    var additionHintContainer = [Int]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadNewProblem()
        gameTimerLabel.text = String(gameTime)
        startGameTimer()
        scoreLabel.text = String(score)
        hintLabel.text = ""
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
        case clearButton:
//            print("Answer")
//            calculate()
            print("Clear")
            answerLabel.text = ""
        case hintButton:
            hint()
        default:
            print("Clear")
            answerLabel.text = ""
        }
    }
    
    func numberTouchedAction(number: Int){
        if let currentLabel = answerLabel.text {
            answerLabel.text = "\(currentLabel)\(String(number))"
        }
        
        guard let answer = answerLabel.text else { return }
        if result == Int(answer) {
            replay()
        }
    }
    
    func replay() {
//        guard let answer = answerLabel.text else { return }
//        if result == Int(answer) {
            loadNewProblem()
            score += 1
            if score != 0 && score % 10 == 0 {
                if flag {
                    numeratorProblemSize *= 10
                    flag = false
                } else {
                    denominatorProblemSize *= 10
                    flag = true
                }
                gameTimeBonus += (numeratorLabel.text!.count)
            }
            gameTime += gameTimeBonus
            gameTimerLabel.text = String(gameTime)
            scoreLabel.text = String(score)
            hintLabel.text = ""
//        } else {
//            answerLabel.textColor = UIColor.red
//            wrongAnswer = true
//        }
    }
    
    func calculate(_ equation: String) -> Int {
//        equation = "\(num1) \(op) \(num2)"
        result = ShuntingYard.parse(equation, operators: operators)
        print("Result: \(result)")
        return result
    }
    
    func loadNewProblem() {
        answerLabel.textColor = UIColor.black
        var num1 = RandomInt(min: number % (numeratorProblemSize/10), max: number % numeratorProblemSize)
        var num2 = RandomInt(min: number % (denominatorProblemSize/10), max: number % denominatorProblemSize)
        
        if num2 > num1 {
            print("swap: \(num1) \(num2)")
            swap(&num1, &num2)
            print("swapped: \(num1) \(num2)")
        }
        
        equation = "\(num1) \(op) \(num2)"
        result = calculate(equation)
//        result = ShuntingYard.parse(equation, operators: operators)
//        print("Result: \(result)")
        
        if num2 < 10 {
            hintButton.isEnabled = false
            hintButton.alpha = 0.2
        } else {
            hintButton.isEnabled = true
            hintButton.alpha = 1
        }
        
        numeratorLabel.text = String(num1)
        denominatorLabel.text = String(num2)
        operatorLabel.text = op
        answerLabel.text = ""
    }
    
    func hint() {
//        print("Hint \(denominatorLabel.text!.count)")
        additionHintContainer.removeAll()
        guard let denominator = denominatorLabel.text, let numerator = numeratorLabel.text
            else {return}
        
        hintLabel.text = """
        \(numerator)
        \(op) \(denominator)
        """
        
        var exponent = denominator.count
        var next: Int = 0
        guard var base = Int(denominator) else {return}
        print("Base: \(base)")
        for _ in 0 ..< denominator.count {
            next = base % Int(pow(10.0, Double(exponent)))
//            print("Next: \(next)")
            if base - next != 0{
                print(base - next)
                additionHintContainer.append(base - next)
            }
            base = next
            exponent -= 1
        }
        if next != 0 {
            print("\(next)")
            additionHintContainer.append(next)
            print(additionHintContainer)
        }
        additionHintCycle(additionHintContainer)
    }
    
    func additionHintCycle(_ additionHintContainer: [Int]) {
////        var hintNum1: Int?
////        var hintNum2: Int?
////        answerLabel.text = ""
//        if hintResult == result {
//            replay()
//        }
//
//        var tempContainer = [Int]()
//        denominatorLabel.text = String(additionHintContainer[0])
//
//        guard let hintNum1 = Int(numeratorLabel.text!), let hintNum2 = Int(denominatorLabel.text!)
//        else { return }
//        let hintEquation = "\(hintNum1) \(op) \(hintNum2)"
//        let hintResult = calculate(hintEquation)
//
//        guard let hintAnswer = answerLabel.text else { return }
//
//        if hintResult == Int(hintAnswer) {
//            tempContainer = additionHintContainer
//            tempContainer = [tempContainer.remove(at: 0)]
//            print(tempContainer)
//            numeratorLabel.text = String(hintResult)
//            additionHintCycle(tempContainer)
//        }
//
    
//        var i: Int = 0
//        while i < additionHintContainer.count {
//            denominatorLabel.text = String(additionHintContainer[i])
//            guard var hintNum1 = Int(numeratorLabel.text!), var hintNum2 = Int(denominatorLabel.text!)
//            else { return }
////            var hintAnswer = hintNum1 + hintNum2
//
//            var hintEquation = "\(hintNum1) \(op) \(hintNum2)"
//            var hintResult = calculate(hintEquation)
//
//            if var hintAnswer = answerLabel.text {
////                while hintResult != Int(hintAnswer) {
////                    hintAnswer = answerLabel.text!
////                }
//            }
//            numeratorLabel.text = String(hintResult)
//            i += 1
////            denominatorLabel.text = String(additionHintContainer[i])
//        }
        
        
//        for i in 1 ..< additionHintContainer.count {
//            print("\(i): \(additionHintContainer[i])")
//        }
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

