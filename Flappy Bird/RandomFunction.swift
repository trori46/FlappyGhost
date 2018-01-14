//
//  RandomFunction.swift
//  Flappy Bird
//
//  Created by Viktoriia Rohozhyna on 1/14/18.
//  Copyright © 2018 Viktoriia Rohozhyna. All rights reserved.
//

import Foundation
import CoreGraphics

public extension CGFloat {
    public static func random() -> CGFloat {
        return CGFloat(Float(arc4random()) / 0xFFFFFFFF)
    }
    
    public static func random(min: CGFloat, max: CGFloat) -> CGFloat {
        return CGFloat.random() * (max - min) + min
    }
}
