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
//    var op: String = plus
    var op: String = minus
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
    var minusHintContainer = [Int]()
    var hintFlag: Bool = false
    var realResult = 0 //to hold the result when the hint flag is true
    var willRoundUp: Bool = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        loadNewProblem()
        loadNewProblem(num1: RandomInt(min: number % (numeratorProblemSize/10), max: number % numeratorProblemSize), num2: RandomInt(min: number % (denominatorProblemSize/10), max: number % denominatorProblemSize), op: op)
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
        
//        if wrongAnswer {
//            wrongAnswer = false
//            answerLabel.text = ""
//            answerLabel.textColor = UIColor.black
//        }
        
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
        if !hintFlag && result == Int(answer) {
            replay()
        } else if hintFlag && Int(answer) == realResult {
            replay()
            print("Hint Cycle Complete")
        } else if hintFlag && result == Int(answer) {
            print("""
                load the next part of the hint
                realResult = \(realResult)
                result = \(result)
                answer = \(answer)
                hintFlag = \(hintFlag)
                """)
            switch op {
            case plus:
                additionHintContainer.remove(at: 0)
                if !additionHintContainer.isEmpty {
                    loadNewProblem(num1: result, num2: additionHintContainer[0], op: op)
                }
            case minus:
                print("Inside of numberTouchedAction() switch case: minus")
                minusHintContainer.remove(at: 0)
                if !minusHintContainer.isEmpty {
                    if !willRoundUp {
                        loadNewProblem(num1: result, num2: minusHintContainer[0], op: minus)
                    } else {
                        loadNewProblem(num1: result, num2: minusHintContainer[0], op: plus)
                    }
                }
            default:
                return
            }
        }
        
    }
    
    func replay() {
        print("replay()")
        
//        if !hintFlag { // uncomment if you want to turn scoring off if hint used
            score += 1
            if score != 0 && score % 10 == 0 {
                if flag {
                    numeratorProblemSize *= 10
                    flag = false
                } else {
                    denominatorProblemSize *= 10
                    flag = true
                }
                gameTimeBonus += (numeratorLabel.text!.count * 2)
            }
            gameTime += gameTimeBonus
            gameTimerLabel.text = String(gameTime)
            scoreLabel.text = String(score)
//        } else {
            hintLabel.text = ""
            hintFlag = false
//        }
        loadNewProblem(num1: RandomInt(min: number % (numeratorProblemSize/10), max: number % numeratorProblemSize), num2: RandomInt(min: number % (denominatorProblemSize/10), max: number % denominatorProblemSize), op: op)
    }
    
    func calculate(_ equation: String) -> Int {
        print("calculate()")
        result = ShuntingYard.parse(equation, operators: operators)
        print("Result: \(result)")
        return result
    }
    
//    func loadNewProblem() {
    func loadNewProblem(num1: Int, num2: Int, op: String) {
        print("loadNewProblem")
        var num1 = num1
        var num2 = num2
        
        if num2 > num1 {
//            print("swap: \(num1) \(num2)")
            swap(&num1, &num2)
//            print("swapped: \(num1) \(num2)")
        }
        
        let numTest = num2 % denominatorProblemSize
        print ("NumTest: \(numTest)")
        
        equation = "\(num1) \(op) \(num2)"
        result = calculate(equation)
        
        if num2 < 10 || hintFlag{
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
        print("hint()")
        hintFlag = true
        realResult = result
        
        guard let denominator = denominatorLabel.text, let numerator = numeratorLabel.text
            else {return}
        
        switch op {
        case plus:
            additionHintContainer.removeAll()
            additionHintContainer = createHintContainer(denominator)
            additionHintContainer = additionHintContainer.filter({$0 != 0})
            printHintLabel(denominator: denominator, container: additionHintContainer, operation: plus)
            loadNewProblem(num1: Int(numerator)!, num2: Int(additionHintContainer[0]), op: op)
            
        case minus:
            minusHintContainer.removeAll()
            willRoundUp = minusHintChoice(numeratorContainer: createHintContainer(numerator), denominatorContainer: createHintContainer(denominator))
            print("Will Round Up: \(willRoundUp)")
            if willRoundUp {
                let tmp = createHintContainer(denominator)
                let hintNumber = (tmp[0] / (denominatorProblemSize/10) + 1) * (denominatorProblemSize/10)
                let difference = hintNumber - Int(denominator)!
                minusHintContainer = createHintContainer(String(hintNumber + difference))
//                minusHintContainer[0] = hintNumber
//                minusHintContainer.insert(hintNumber, at: 0)
                print("Rounded up container: \(minusHintContainer)")
                printHintLabel(denominator: denominator, container: minusHintContainer, operation: minus)
//                loadNewProblem(num1: Int(numerator)!, num2: minusHintContainer[0], op: plus)
            } else {
                minusHintContainer = createHintContainer(denominator)
                minusHintContainer = minusHintContainer.filter({$0 != 0})
                printHintLabel(denominator: denominator, container: minusHintContainer, operation: plus)
//                loadNewProblem(num1: Int(numerator)!, num2: minusHintContainer[0], op: minus)
            }
            loadNewProblem(num1: Int(numerator)!, num2: minusHintContainer[0], op: minus)
        default:
            return
        }
        
    }
    
    func printHintLabel(denominator: String?, container: [Int], operation: String) {
        guard let denominator = denominator else { return }
        hintLabel.text = "\(denominator) = \(container[0])"
        for i in 1..<container.count {
            var current = hintLabel.text!
            current = "\(current) \(operation) \(container[i])"
            hintLabel.text = current
        }
    }
    
    func minusHintChoice(numeratorContainer: [Int], denominatorContainer: [Int]) -> Bool {
        for i in stride(from: denominatorContainer.count-1, to: 0, by: -1) {
            if denominatorContainer[i] > numeratorContainer[i] {
                return true
            }
        }
        return false
    }
    
    
    func createHintContainer(_ str: String) -> [Int] {
        var hintContainer = [Int]()
        var exponent = str.count - 1
        var next: Int = 0
        if var base = Int(str) {
            print("Base: \(base)")
            for _ in 1 ..< str.count {
                next = base % Int(pow(10.0, Double(exponent)))
                //            print("Next: \(next)")
//                if base - next != 0{
                    print(base - next)
                    hintContainer.append(base - next)
//                }
                base = next
                exponent -= 1
            }
//            if next != 0 {
                print("\(next)")
                hintContainer.append(next)
                print(hintContainer)
//            }
        }
        return hintContainer
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

