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
    func spawnasteroids(random: GKRandomSource){
        let amountrd = GKRandomDistribution(randomSource: random, lowestValue: 4, highestValue: 11)
        let kindrd = GKRandomDistribution(randomSource: random, lowestValue: 1, highestValue: 11)
        let positionrd = GKRandomDistribution(randomSource: random, lowestValue: -100, highestValue: 100)
        let amount = amountrd.nextInt()
        
        var numtable = [Int]()
        for _ in 1..<amount+1 {
            
            //chose unique kind
            var newint = kindrd.nextInt()
            while(numtable.contains(newint)){
                newint = kindrd.nextInt()
            }
            numtable.append(newint)
            let pos = CGPoint(x: Int(self.position.x) + positionrd.nextInt(), y: Int(self.position.y) + positionrd.nextInt())
            let asteroid = Asteroid(scene: self.game, kind: newint, size: self.dim, position: pos)
            self.parent?.addChild(asteroid)
        }

    }
    //MARK: - UPDATE
    func update(){
        
    }
    
}
