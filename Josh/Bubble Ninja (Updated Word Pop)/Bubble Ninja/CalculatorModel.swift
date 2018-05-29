import Foundation
/*
 This is the Shunting-yard algorithm with a Calculation algorith to convert conventional string input into Reverse Polish Notation and then evaluate the equation to return an Integer result.
 
 This is achieved by reading the input as a seperated by white space. Numbers are added to a queue and operators to a stack.
 
 Operator precedence is evaluated and if the operator at the top of the stack has a lower precedence then the operators beneath it in the stack, the stack is popped and added to the number queue.
 
 Note - the lower precedent operator is not added to the queue but is added to the top of the operator stack
 
 This is an amended varation of the Shunting-yard algorithm found at:
 http://rosettacode.org/wiki/Parsing/Shunting yard_algorithm#Swift
 
 The amendments are a simplifed version of the example as the scope of the assignment doesn't require expotentials, the modulus operator is added, the equation is calculated and modifications to accomodate Swift 4
 */

//Custom Error Types
enum evaluationError: Error {
    case UnrecognisedOperation
    case DivideByZero
}

//Define operator constants
let plus: String = "+"
let minus: String = "-"
let times: String = "x"
let divideBy: String = "/"
let remander: String = "%"

//Define Operators with precedence
let operators: Set<Operator> = [
    Operator(remander, 3),
    Operator(times, 3),
    Operator(divideBy, 3),
    Operator(plus, 2),
    Operator(minus, 2)
]

//Custom abstract data type - Stack
struct Stack<T>{
    private(set) var elements = [T]()
    var isEmpty: Bool {return elements.isEmpty}
    var hasOne: Bool {return elements.count == 1}
    
    mutating func push(newElement: T){
        elements.append(newElement)
    }
    
    mutating func pop() -> T{
        return elements.removeLast()
    }
    
    mutating func clear() {
        elements.removeAll()
    }
    
    func top() -> T?{
        return elements.last
    }
}

//Custom abstract data type - Queue
struct Queue<T>{
    private(set) var elements = [T]()
    var isEmpty: Bool {return elements.isEmpty}
    
    mutating func enque(newElement: T){
        elements.append(newElement)
    }
    
    mutating func deque(){
        elements.removeFirst()
    }
}

/*
 * References:
 * https://www.tutorialspoint.com/swift/swift_protocols.htm
 * https://developer.apple.com/library/content/documentation/Swift/Conceptual/Swift_Programming_Language/Protocols.html
 */
protocol OperatorType: Comparable, Hashable{
    var name: String {get}
    var precedence: Int {get}
}

struct Operator: OperatorType {
    let name: String
    let precedence: Int
    var hashValue: Int {return "\(name)".hashValue}
    
    init(_ name: String, _ precedence: Int) {
        self.name = name
        self.precedence = precedence
    }
}

func ==(x: Operator, y: Operator) -> Bool{
    return x.name == y.name
}

func <(x: Operator, y: Operator) -> Bool {
    return x.precedence <= y.precedence
}

/*
 * References:
 * https://www.tutorialspoint.com/swift/swift_extensions.htm
 * https://developer.apple.com/library/content/documentation/Swift/Conceptual/Swift_Programming_Language/Extensions.html
 */
//This is to see if the token is an operator
extension Set where Element: OperatorType {
    func contains(op: String?) -> Bool {
        guard let operatorName = op else { return false }
        return contains { $0.name == operatorName }
    }
    
    subscript (operatorName: String) -> Element? {
        get {
            return filter { $0.name == operatorName }.first
        }
    }
}

extension String {
    var isNumber: Bool { return Int(self) != nil }
}

//This converts a conventional arithmatic equation into Reverse Polish Notation then passes the converted equation to the calculator for evaluation
struct ShuntingYard {
    //This is the function that parses the input string into Reverse Polish Notation output then evaluates the equation
    static func parse(_ input: String, operators: Set<Operator>) -> Int {
        var stack = Stack<String>()
        var output = Queue<String>()
        let tokens = input.components(separatedBy: " ")
        //  Parsing the input string seperated by space
        for token in tokens {
            // Add numbers to the output queue
            if token.isNumber {
                output.enque(newElement: token)
            } else if operators.contains(op: token) {
                // While there is a operator on top of the stack and has lower precedence than current operator add to output string
                while operators.contains(op: stack.top()) && hasLowerPrecedence(x: token, stack.top()!, operators) {
                    output.enque(newElement: String(stack.pop()))
                }
                // Otherwise push the operator onto the operator statck
                stack.push(newElement: token)
            } else if token == "(" {
                // Deal with openning parenthese to maintain order of operations by pushing operator onto the stack
                stack.push(newElement: token)
            } else if token == ")" {
                // Deal with closing parenthese. This is the signal to pop the stack and add the the output queue
                while !stack.isEmpty && stack.top() != "(" {
                    output.enque(newElement: stack.pop())
                }
                // If stack runs out there is no closing parenthese throw error
                if stack.isEmpty{
                    print("No closing parenthese")
                    exit(1)
                }
                // Disregard the "("
                var _ = stack.pop()
            } else {
                print("Unrecognised Input: "+token)
                exit(1)
            }
        }
        // Empty the operator stack after all tokens have been read
        while operators.contains(op: stack.top()) {
            output.enque(newElement: stack.pop())
        }
        //  Pass the the calculator here and return the solution
        //        return calculate(equation: output.elements)!
        return calculate(equation: output.elements)!
        //        return String(calculate(equation: output.elements)!)
    }
    
    // This function is a comparitor of operator precedence
    static private func hasLowerPrecedence(x: String, _ y: String, _ operators: Set<Operator>) -> Bool {
        guard let first = operators[x], let second = operators[y] else { return false }
        return first < second
    }
    
    //This is the funciton to calculate the parseed equation which is now in Reverse Polish Notation
    static private func calculate(equation: [String]) -> Int?{
        var resultStack = Stack<String>()
        //    Array to catch the evaluation overflow
        var overflow = [String]()
        //    Count the numbers popped off the stack. If two -> pass to evaluation
        var cnt: Int = 0
        //    Push the equation onto the result statck
        for e in equation {
            resultStack.push(newElement: e)
        }
        //  If there are still varables to evaluate
        if !resultStack.hasOne {
            //   Evaluatute the equation
            while !resultStack.isEmpty{
                //   Pop the result stack and check for an operator and 2 numbers to evaluate
                let op = resultStack.pop()
                overflow.append(op)
                if isNumber(string: op){ cnt += 1 } else { cnt = 0 }
                //   If there are 2 numbers and an operation to evaluate extract the numbers and operator and evaluate
                if cnt == 2 {
                    let opLeft = Int(overflow.removeLast())
                    let opRight = Int(overflow.removeLast())
                    let operation = overflow.removeLast()
                    do {
                        try overflow.append(evaluate(opLeft: opLeft!, opRight: opRight!, operation: operation))
                    } catch evaluationError.DivideByZero {
                        print("Can't divide by 0")
                        exit(1)
                    } catch evaluationError.UnrecognisedOperation {
                        print("Unknown operator: "+operation)
                        exit(1)
                    } catch {
                        print("We've got a problem: \(error)")
                        exit(2)
                    }
                    //   Push the overflow in the result array back onto the stack
                    while !overflow.isEmpty {
                        resultStack.push(newElement: overflow.removeLast())
                    }
                    //   Recursive Calculator call
                    return calculate(equation: resultStack.elements)
                }
            }
        }
        //  Evaluation is complete, return the result
        return Int(resultStack.elements[0])
    }
    
    //This function evaluates equations
    static private func evaluate(opLeft: Int, opRight: Int, operation: String) throws -> String {
        var result: Int? = nil
        switch operation {
        case plus:
            result = opLeft + opRight
        case minus:
            result = opLeft - opRight
        case times:
            result = opLeft * opRight
        case divideBy:
            do {
                try result = divide(opLeft: opLeft, opRight: opRight)
            } catch {
                throw evaluationError.DivideByZero
            }
        case remander:
            result = opLeft % opRight
        default:
            throw evaluationError.UnrecognisedOperation
        }
        return String(result!)
    }
    
    //Deal with special case, divide by 0
    static private func divide(opLeft: Int, opRight: Int) throws -> Int{
        var result: Int? = nil
        if opRight != 0 {
            result = opLeft / opRight
            return result!
        } else {
            throw evaluationError.DivideByZero
        }
    }
    
    //Convenience to check if is a number
    static private func isNumber(string :String) -> Bool {
        var isNumber: Bool { return Int(string) != nil }
        return isNumber
    }
}

