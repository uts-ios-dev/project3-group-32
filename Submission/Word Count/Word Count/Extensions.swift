//
//  Extensions.swift
//
//  Created by Charlie Sweeney on 21/5/18.
//  Copyright © 2018 Charlie Sweeney. All rights reserved.
//

import Foundation
import CoreGraphics
import SpriteKit

public func + (left: CGPoint, right: CGPoint) -> CGPoint {
    return CGPoint(x: left.x + right.x, y: left.y + right.y)
}

public func += (left: inout CGPoint, right: CGPoint) {
    left = left + right
}
