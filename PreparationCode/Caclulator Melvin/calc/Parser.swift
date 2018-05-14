//
//  Parser.swift
//  calc
//
//  Parser struct helps convert string expressions to operator enum values and operand integer values. These values are then used to evaluate expressions.
//
//  Created by Melvin Philip on 24/3/18.
//  Copyright © 2018 UTS. All rights reserved.
//

import Foundation

struct Parser{
    
    func isOperand(_ string: String) -> Int? {
        return Int(string)
    }
    
    func isOperator(_ string: String)-> Operator? {
        if(string.count == 1) {
            switch string {
            case "+":
                return Operator.plus
            case "-":
                return Operator.minus
            case "/":
                return Operator.divider
            case "x":
                return Operator.multiplier
            default:
                return Operator.modulus
            }
        } else {
            return nil
        }
    }
    
    func operatorToString(_ op: Operator) -> String {
        switch op {
        case Operator.divider:
            return "/"
        case Operator.multiplier:
            return "x"
        case Operator.plus:
            return "+"
        case Operator.minus:
            return "-"
        default:
            return "%"
        }
    }
}
