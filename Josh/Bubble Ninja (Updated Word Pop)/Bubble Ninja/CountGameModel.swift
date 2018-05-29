//
//  Count Game Model.swift
//  Count v1
//
//  Created by Clint Sellen on 15/5/18.
//  Copyright © 2018 UTS. All rights reserved.
//

import Foundation

struct countGameModel {
    var numerator = 0
    var denominator = 0
    
    func generator(minSize: Int, maxSize: Int) -> Int {
        return RandomInt(min: 10, max: 999)
    }
    
}


