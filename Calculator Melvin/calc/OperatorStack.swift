//
//  OperatorStack.swift
//  calc
//
//  Stack to hold Operators. Helper struct for NotationConverter, to help convert expression to postfix notation.
//
//  Created by Melvin Philip on 24/3/18.
//  Copyright © 2018 UTS. All rights reserved.
//

import Foundation

struct OperatorStack{
    
    var array: [Operator] = []
    
    mutating func push(element: Operator) {
        array.append(element)
    }
    
    mutating func pop() -> Operator? {
        return array.popLast()
    }
    
    func peek() -> Operator? {
        return array.last
    }
    
    func isEmpty() -> Bool {
        return array.isEmpty
    }
    
    func size() -> Int {
        return array.count
    }
    
    mutating func clear() {
        while(array.count != 0){
            array.removeLast()
        }
    }
}
