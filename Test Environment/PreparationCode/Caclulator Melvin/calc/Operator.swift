//
//  Operator.swift
//  calc
//
//  Enum used to define mathematical operator precedence.
//
//  Created by Melvin Philip on 24/3/18.
//  Copyright © 2018 UTS. All rights reserved.
//

import Foundation

enum Operator: Int {
    case divider = 6
    case multiplier = 5
    case plus = 3
    case minus = 2
    case modulus = 0
}
