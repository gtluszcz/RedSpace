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
    static let Enemy: UInt32 = 0b100000000
    static let Minefield: UInt32 = 0b10
    static let Mine: UInt32 = 0b100
    static let Planet: UInt32 = 0b1000
    static let Asteroid: UInt32 = 0b10000
    static let Laser: UInt32 = 0b100000
    static let Explosion: UInt32 = 0b1000000
    static let PartitionPush: UInt32 = 0b10000000

    
}
