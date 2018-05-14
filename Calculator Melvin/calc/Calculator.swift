//
//  Calculator.swift
//  calc
//
//  Calculator struct caluclates postfix expressions.
//
//  Created by Melvin Philip on 24/3/18.
//  Copyright © 2018 UTS. All rights reserved.
//

import Foundation

struct Calculator{
    
    var expressionStack: ExpressionStack = ExpressionStack()
    var parser: Parser = Parser()
    
    var operandOne: Int = 0
    var operandTwo: Int = 0
    var op: Operator = Operator.plus
    var result: String = ""
    
    //Calculate a postfix expression and return an integer.
    mutating func calculate(_ expression: [String]) -> Int {
        //print(expression)
        
        for value in expression {
            if(parser.isOperand(value) != nil){
                expressionStack.push(element: value)
            } else if(parser.isOperator(value) != nil && expressionStack.size() >= 2) {
                op = parser.isOperator(value)!
                operandTwo = Int(expressionStack.pop()!)!
                operandOne = Int(expressionStack.pop()!)!
                result = compute(op, operandOne, operandTwo)
                expressionStack.push(element: result)
            } else if(parser.isOperator(value) != nil && expression.count==1) {
                exit(EXIT_FAILURE)
            } else {
                exit(EXIT_FAILURE)
            }
            //print(expressionStack)
        }
        
       
        
        if(expressionStack.isEmpty()) {
                exit(EXIT_SUCCESS)
        }
        
        return Int(expressionStack.peek()!)!
        
    }
    
    
    //Calculate a value given to integers and an operand. Returns value as a string.
    func compute(_ op: Operator,_ operandOne: Int,_ operandTwo: Int) -> String{
        
        let opdOne: Int = operandOne
        let opdTwo: Int = operandTwo
        
        switch op {
        case Operator.divider:
            return String(divide(opdOne,opdTwo))
        case Operator.multiplier:
            return String(multiply(opdOne,opdTwo))
        case Operator.plus:
            return String(add(opdOne,opdTwo))
        case Operator.minus:
            return String(subtract(opdOne,opdTwo))
        default:
            return String(modulus(opdOne,opdTwo))
        }
    }
    
    func add(_ OperandOne: Int,_ OperandTwo: Int) -> Int{
        return operandOne + operandTwo;
    }
    
    func subtract(_ OperandOne: Int,_ OperandTwo: Int) -> Int{
        return operandOne - operandTwo
    }
    
    func multiply(_ OperandOne: Int,_ OperandTwo: Int) -> Int{
        return operandOne * operandTwo
    }
    
    func divide(_ OperandOne: Int,_ OperandTwo: Int) -> Int{
        return (operandOne / operandTwo)
    }
    
    func modulus(_ OperandOne: Int,_ OperandTwo: Int) -> Int{
        return (operandOne % operandTwo)
    }
    
    
}
