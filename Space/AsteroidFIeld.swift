//
//  AsteroidFIeld.swift
//  Space
//
//  Created by Henryk on 21.03.2017.
//  Copyright © 2017 Grzegorz Tłuszcz Team. All rights reserved.
//

import GameKit
import SpriteKit
import Foundation

class AsteroidField: SKNode{
    //MARK: PROPERTIES
    var dim: CGFloat!
    var game: GameScene!

    
    //MARK: - INIT
    override init(){
       super.init()
    }
    convenience init(scene: GameScene, position: CGPoint, maxradius: CGFloat, unit: CGFloat, random: GKRandomSource) {
        self.init()
        self.game = scene
        setup(position: position, maxradius: maxradius, unit: unit, random: random)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - SETUP
    func setup(position: CGPoint, maxradius: CGFloat, unit: CGFloat, random: GKRandomSource){
        //set properties
        self.position = position
        self.dim = unit
        //append to groups
        self.game.asteroidfields.append(self)
        
        //self.spawnasteroids(random: random)
    }
    
    //MARK: - FUNCTIONALITIES
    func spawnasteroids(random: GKRandomSource, maxradius: CGFloat){
        let amountrd = GKRandomDistribution(randomSource: random, lowestValue: 4, highestValue: min(Int(maxradius) / 15,11))
        let kindrd = GKRandomDistribution(randomSource: random, lowestValue: 1, highestValue: 1000)
        let positionrd = GKRandomDistribution(randomSource: random, lowestValue: max(-(Int)(maxradius),-150), highestValue: min(Int(maxradius),150))
        let amount = amountrd.nextInt()
        
        for _ in 1..<amount+1 {
            
            //chose unique kind
            let newint = kindrd.nextInt()
            let pos = CGPoint(x: Int(self.position.x) + positionrd.nextInt(), y: Int(self.position.y) + positionrd.nextInt())
            let asteroid: Asteroid!
            switch newint {
            case 1..<20:
                asteroid = Asteroid(scene: self.game, kind: 1, position: pos)
//            case 5..<10:
//                asteroid = Asteroid(scene: self.game, kind: 2, position: pos)
            case 20..<120:
                asteroid = Asteroid(scene: self.game, kind: 3, position: pos)
            case 120..<140:
                asteroid = Asteroid(scene: self.game, kind: 4, position: pos)
            case 140..<290:
                asteroid = Asteroid(scene: self.game, kind: 5, position: pos)
            case 290..<505:
                asteroid = Asteroid(scene: self.game, kind: 6, position: pos)
            case 505..<650:
                asteroid = Asteroid(scene: self.game, kind: 7, position: pos)
            case 650..<800:
                asteroid = Asteroid(scene: self.game, kind: 8, position: pos)
            case 800..<900:
                asteroid = Asteroid(scene: self.game, kind: 9, position: pos)
            case 900..<1000:
                asteroid = Asteroid(scene: self.game, kind: 10, position: pos)
            default:
                asteroid = Asteroid(scene: self.game, kind: 5, position: pos)
            }
            self.parent?.addChild(asteroid)
        }

    }
    //MARK: - UPDATE
    func update(){
        
    }
    
}
