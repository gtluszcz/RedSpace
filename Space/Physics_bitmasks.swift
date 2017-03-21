//
//  Physics_bitmasks.swift
//  Space
//
//  Created by Henryk on 04.03.2017.
//  Copyright © 2017 Grzegorz Tłuszcz Team. All rights reserved.
//

import Foundation

struct PhysicsCategory{
    static let None: UInt32 = 0
    static let Player: UInt32 = 0b1
    static let Bombfield: UInt32 = 0b10
    static let Mine: UInt32 = 0b100
    static let Planet: UInt32 = 0b1000
    static let NormalAsteroid: UInt32 = 0b10000
    
}
