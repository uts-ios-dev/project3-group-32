//
//  main.swift
//  calc
//
//  Created by Jesse Clark on 12/3/18.
//  Copyright © 2018 UTS. All rights reserved.
//

import Foundation


//Obtain expression from command line, dropping the first program path argument
let arguments = CommandLine.arguments.dropFirst()

//Create a notation converter struct. Used to convert infix expressions to postfix expressions.
var converter: NotationtConverter = NotationtConverter()

//Create a calculator struct to evaluate postfix expression
var calculator: Calculator = Calculator()

//Convert expression to a postfix notation array
let expression = converter.convert(inputArray: arguments)

//Calculate postfix expression and print on screen
print(calculator.calculate(expression!))


