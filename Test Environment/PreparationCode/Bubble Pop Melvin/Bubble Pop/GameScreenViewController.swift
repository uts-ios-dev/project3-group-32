//
//  GameScreenViewController.swift
//  Bubble Pop
//
//  Created by Melvin Philip on 29/4/18.
//  Copyright © 2018 Melvin Philip. All rights reserved.
//

import UIKit

class GameScreenViewController: UIViewController {

    
    var bubbles = [UIButton] ()
    var bubbleCoordinates = [CGPoint] ()
    
    var xCoordinates = [CGFloat] ()
    var yCoordinates = [CGFloat] ()
    var bubbleHeights = [CGFloat] ()
    var bubbleWidths = [CGFloat] ()
    
    var game:Game = Game()
    var gameTimer = Timer()
    var gameTimeRemaining:Int = 0;
    
    
    var playerName:String!
    var gameTime:Int!
    var numberOfBubbles:Int!
 
    
    @IBOutlet weak var bubbleOne: UIButton!
    @IBOutlet weak var bubbleTwo: UIButton!
    @IBOutlet weak var bubbleThree: UIButton!
    @IBOutlet weak var bubbleFour: UIButton!
    @IBOutlet weak var bubbleFive: UIButton!
    @IBOutlet weak var bubbleSix: UIButton!
    @IBOutlet weak var bubbleSeven: UIButton!
    @IBOutlet weak var bubbleEight: UIButton!
    @IBOutlet weak var bubbleNine: UIButton!
    @IBOutlet weak var bubbleTen: UIButton!
    @IBOutlet weak var bubbleEleven: UIButton!
    @IBOutlet weak var bubbleTwelve: UIButton!
    @IBOutlet weak var bubbleThirteen: UIButton!
    @IBOutlet weak var bubbleFourteen: UIButton!
    @IBOutlet weak var bubbleFifteen: UIButton!
    
    @IBOutlet weak var gameScore: UILabel!
    @IBOutlet weak var gameTimerLabel: UILabel!
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpGamePreferences()
        setUpBubblesArray()
        setUpBubbleDisplay()
        setUpBubblePositions()
        setUpGame()
        
    }
    
    //Creating game object using user settings.
    func setUpGamePreferences() {
        game = Game(playerName: playerName, gameTime: gameTime, numberOfBubbles: numberOfBubbles)
    }
    
    //Setting up bubbles for game. Assumption is that game will only have
    //15 bubbles.
    func setUpBubblesArray(){
        bubbles.append(bubbleOne)
        bubbles.append(bubbleTwo)
        bubbles.append(bubbleThree)
        bubbles.append(bubbleFour)
        bubbles.append(bubbleFive)
        bubbles.append(bubbleSix)
        bubbles.append(bubbleSeven)
        bubbles.append(bubbleEight)
        bubbles.append(bubbleNine)
        bubbles.append(bubbleTen)
        bubbles.append(bubbleEleven)
        bubbles.append(bubbleTwelve)
        bubbles.append(bubbleThirteen)
        bubbles.append(bubbleFourteen)
        bubbles.append(bubbleFifteen)
        hideBubbles()
        refreshBubbles()
    }
    
    
    //Setting up bubbles to be display
    func setUpBubbleDisplay(){
        for bubble in bubbles {
            //Set Size
            bubble.bounds.size.height = 50
            bubble.bounds.size.width = bubble.bounds.size.height
            
            //Round Button
            bubble.layer.cornerRadius =  0.5 * bubble.bounds.size.width
            bubble.layer.masksToBounds = true
            bubble.clipsToBounds = true
            
            //Clear Button Text
            bubble.setTitle("", for: .normal)
            
            //Set Tag
            bubble.tag = chooseBubble()
            
            //Set Background Color
            bubble.backgroundColor = chooseColor(bubble)
        }
    }
    
    
    //Places all bubbles at random points on screen.
    func setUpBubblePositions(){
        for bubble in bubbles {
            displayRandom(bubble)
        }
        clearScreen()
    }
    
    //Controlling bubble tap action depending on bubbble colour.
    @IBAction func bubbleTapped(_ sender: AnyObject) {
        
        guard let bubble = sender as? UIButton else {
            return
        }
        
        switch sender.tag {
        case 1:
            buttonTapped(bubble, Bubble.pink)
        case 2:
            buttonTapped(bubble, Bubble.green)
        case 3:
            buttonTapped(bubble, Bubble.blue)
        case 4:
            buttonTapped(bubble, Bubble.black)
        default:
            buttonTapped(bubble, Bubble.red)
        }
    }
    
    //Refreshes game data as game progresses
    func refreshScreen(){
        gameScore.text = String(game.getGameScore())
    }
    
    
    
    //Hiding bubble and passing bubble to game to calculate score and then
    //refreshing game data shown on screen.
    func buttonTapped(_ button: UIButton, _ bubble: Bubble){
        button.isHidden = true;
        game.bubblePopped(bubble)
        refreshScreen()
    }
    
   
    //Sets up game timer and game environment.
    func setUpGame(){
        gameTimeRemaining = game.getTime()
        gameTimerLabel.text = String(gameTimeRemaining)
        gameTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(GameScreenViewController.runningGame), userInfo: nil, repeats: true)
    }
    
    
    //Increments timer and refreshes screen while game is running.
    @objc func runningGame(){
        hideBubbles()
        gameTimeRemaining -= 1
        gameTimerLabel.text = String(gameTimeRemaining)
        refreshBubbles()
        
        if(gameTimeRemaining) == 0 {
            gameTimer.invalidate()
            disableBubbles()
        
            Timer.scheduledTimer(timeInterval: 2,
                                 target: self,
                                 selector: #selector(GameScreenViewController.finishedGame),
                                 userInfo: nil,
                                 repeats: false)
        }
       
    }
    
    //When game timer is finished, game data is passed onto finish screen.
    @objc func finishedGame(){
        let viewCont = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "finalScoreScreen") as! FinalScoreScreenViewController
        viewCont.finalScore = gameScore.text
        viewCont.playerName = game.getPlayerName()
        self.present(viewCont, animated: false, completion: nil)
    }
    
    
    //Disables all bubbles, to prevent user tapping bubble.
    func disableBubbles(){
        for bubble in bubbles{
            bubble.isEnabled = false
        }
    }
    
    
    //Hides all bubbles.
    func hideBubbles(){
        for bubble in bubbles{
            bubble.isHidden = true
        }
    }
    
    //Sets up bubbles upon screen refresh
    func refreshBubbles(){
        let numberOfRandomBubbles = Int(arc4random_uniform(UInt32(numberOfBubbles)) + 1)
        
        for i in 0..<numberOfRandomBubbles {
            bubbles[i].isHidden = false
            setUpBubbleDisplay()
            setUpBubblePositions()
        }
    }
    
   
    
   
    //Clears recorded bubble coordinates on screen refresh/clear
    func clearScreen(){
        xCoordinates.removeAll()
        yCoordinates.removeAll()
    }
    

    //Chooses Bubble Colour based on probability rules:
    //   Red   40%
    //   Pink  30%
    //   Green 15%
    //   Blue  10%
    //   Black 5%
    //
    func chooseBubble() -> Int {
        let bubbleNumber = arc4random_uniform(100)
        
        switch bubbleNumber {
            case 0..<30:
                return Bubble.pink.rawValue
            case 30..<45:
                return Bubble.green.rawValue
            case 45..<55:
                return Bubble.blue.rawValue
            case 55..<60:
                return Bubble.black.rawValue
            default:
                return Bubble.red.rawValue
        }
    }
    
    //Sets bubble colour
    func chooseColor(_ bubble: UIButton) -> UIColor {
        let colorNumber = bubble.tag
        
        switch colorNumber {
            case Bubble.red.rawValue:
                return UIColor.red
            case Bubble.pink.rawValue:
                return UIColor.magenta
            case Bubble.green.rawValue:
                return UIColor.green
            case Bubble.blue.rawValue:
                return UIColor.blue
            case Bubble.black.rawValue:
                return UIColor.black
            default:
                return UIColor.red
        }
    }
    
    //Displays given bubble at random positions on screen without overlap.
    func displayRandom(_ button: UIButton) {
        
        //Screen & Button Values
        let screenHeight = button.superview!.bounds.height
        let screenWidth = button.superview!.bounds.width
        let buttonWidth = button.frame.width
        let buttonHeight = button.frame.height
        let buffer = CGFloat(5.0)
        
        //New Button Coordinates
        var xCoordinate:CGFloat = CGFloat(0)
        var yCoordinate:CGFloat = CGFloat(0)
       
        //Logic controls.
        var acceptableXCoordinate = false
        var acceptableYCoordinate = false
       
        
        //Ensuring xCoordinates are acceptable and do not cause bubble overlaps.
        while(acceptableXCoordinate == false){
            xCoordinate = CGFloat(arc4random_uniform(UInt32(screenWidth - button.frame.width)))
            
            
            var conflictingValueFound = false
            rangeCheckX: for xValue in xCoordinates {
                if(xCoordinate < xValue){
                    if(xCoordinate + (buttonWidth) + buffer > xValue){
                        conflictingValueFound = true
                        break rangeCheckX
                    }
                }
                
                if(xCoordinate > xValue){
                    if(xCoordinate < xValue + (buttonWidth) + buffer){
                        conflictingValueFound = true
                        break rangeCheckX
                    }
                }
            }
            
            
            if(xCoordinates.isEmpty){
                acceptableXCoordinate = true
            }
            
            if(conflictingValueFound == false) {
                acceptableXCoordinate = true
            }
        }
        
        //Ensuring yCoordinates are acceptable and do not cause bubble overlaps.
        while(acceptableYCoordinate == false){
            
            yCoordinate = CGFloat(arc4random_uniform(UInt32(screenHeight - button.frame.height)))
            
            var conflictingValueFound = false
            rangeCheckY: for yValue in yCoordinates {
                if(yCoordinate < yValue){
                    if(yCoordinate + (buttonHeight) + buffer > yValue){
                        
                        conflictingValueFound = true
                        break rangeCheckY
                    }
                }
                
                if(yCoordinate > yValue){
                    if(yCoordinate  < yValue + buttonHeight + buffer){
                        conflictingValueFound = true
                        break rangeCheckY
                    }
                }
            }
            
            
            if(xCoordinates.isEmpty){
                acceptableYCoordinate = true
            }
            
            if(conflictingValueFound == false) {
                acceptableYCoordinate = true
            }
        }
        
        
    
        //Adjusting coordinate for bubble area.
        button.center.x = xCoordinate + (button.frame.width/2)
        button.center.y = yCoordinate + (button.frame.height/2)
        
        
        //Adding bubbles coordinates to array to keep track of bubble positions
        xCoordinates.append(xCoordinate);
        yCoordinates.append(yCoordinate);
    }

}
