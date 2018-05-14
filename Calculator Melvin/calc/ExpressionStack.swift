//
//  ExpressionStack.swift
//  calc
//
//  Stack to hold expression. Helper struct for NotationConverter, to help convert expression to postfix notation.
//
//  Created by Melvin Philip on 24/3/18.
//  Copyright © 2018 UTS. All rights reserved.
//

import Foundation

struct ExpressionStack{
    
    var array: [String] = []
    
    mutating func push(element: String) {
        array.append(element)
    }
    
    mutating func pop() -> String? {
        return array.popLast()
    }
    
    func peek() -> String? {
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
            array.popLast()
        }
    }
    
}
