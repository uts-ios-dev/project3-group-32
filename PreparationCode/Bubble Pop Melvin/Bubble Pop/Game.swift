//
//  Game.swift
//  Bubble Pop
//
//  Struct defining game model.
//
//  Created by Melvin Philip on 29/4/18.
//  Copyright © 2018 Melvin Philip. All rights reserved.
//

import Foundation

struct Game {
    
    let playerName: String
    let gameTime: Int
    let numberOfBubbles: Int
    var gameScore: Int
    var lastBubblePopped: Bubble?
    
    init() {
        playerName = ""
        gameTime = 0
        numberOfBubbles = 0
        gameScore = 0
    }
    
    init(playerName: String, gameTime: Int, numberOfBubbles: Int){
        self.playerName = playerName
        self.gameTime = gameTime
        self.numberOfBubbles = numberOfBubbles
        gameScore = 0
    }
    
    func getPlayerName() -> String {
        return playerName;
    }
    
    func getGameScore() -> Int {
        return gameScore;
    }
    
    func getTime() -> Int{
        return gameTime;
    }
    
    func getLastBubblePopped() -> Bubble? {
        return lastBubblePopped;
    }
    
    //Sequential bubble pop score multiplier
    mutating func bubblePopped(_ bubble: Bubble){
        let poppedBubbleScore = getBubbleScore(bubble)
        
        if(lastBubblePopped == bubble){
            gameScore += Int(round(Double(poppedBubbleScore) * 1.5))
            lastBubblePopped = bubble
        } else {
            gameScore += poppedBubbleScore
            lastBubblePopped = bubble
        }
    }
    
    //Bubble pop score selector
    func getBubbleScore(_ bubble: Bubble) -> Int{
        switch bubble{
        case .red:
            return 1;
        case .pink:
            return 2;
        case .green:
            return 5;
        case .blue:
            return 8;
        case .black:
            return 10;
        }
    }
}
