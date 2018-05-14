//
//  NotationConverter.swift
//  calc
//
//  Notation converter converts an infix expression to a postfix expression.
//
//  Created by Melvin Philip on 24/3/18.
//  Copyright © 2018 UTS. All rights reserved.
//

import Foundation

struct NotationtConverter {
    
    var returnArray: [String] = []
    let notationParser: Parser = Parser()
    var operatorStack: OperatorStack = OperatorStack()
    
    
    //Convert an infix expression array to a postfix expression array.
    mutating func convert(inputArray: ArraySlice<String>) -> [String]? {
        
        for string in inputArray {
            if(notationParser.isOperand(string) != nil) {
                returnArray.append(string)
            } else if(notationParser.isOperator(string) != nil){
                let opPush = notationParser.isOperator(string)!
                
                if((operatorStack.isEmpty()) || ((operatorStack.peek()!.rawValue < opPush.rawValue) && (opPush.rawValue - operatorStack.peek()!.rawValue)>1)){
                    operatorStack.push(element: opPush)
                } else if(((opPush.rawValue - operatorStack.peek()!.rawValue)<=1)){
                    let opPop = operatorStack.pop()!
                    returnArray.append(notationParser.operatorToString(opPop))
                    operatorStack.push(element: opPush)
                } else {
                    while (operatorStack.size() != 0 && (operatorStack.peek()!.rawValue >= opPush.rawValue)){
                        let opPop = operatorStack.pop()!
                        returnArray.append(notationParser.operatorToString(opPop))
                    }
                    operatorStack.push(element: opPush)
                }
            } else if((notationParser.isOperand(string)) != nil && (inputArray.count == 1)) {
                exit(EXIT_FAILURE)
            } else {
                exit(EXIT_FAILURE)
            }
            //print(returnArray)
        }
        
        while (operatorStack.size() != 0){
            let op = operatorStack.pop()!
            returnArray.append(notationParser.operatorToString(op))
        }
        
        return returnArray
    }
}
