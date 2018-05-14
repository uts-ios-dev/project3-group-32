import Foundation

//This is for running calcTest
var args = ProcessInfo.processInfo.arguments
args.removeFirst() // remove the name of the program
var input = args.joined(separator: " ")
//print(input)

//This is for human input
//print("Enter an equaiton seperated with spaces")
//let input = readLine()!

//Pass the equation to the calculator
let output = ShuntingYard.parse(String(input), operators: operators)
//args[0] = String(output)
print(output)
