//
//  Enemy2.swift
//  Space
//
//  Created by Henryk Tłuszcz on 30.07.2017.
//  Copyright © 2017 Grzegorz Tłuszcz Team. All rights reserved.
//
import Foundation

import SpriteKit
import Foundation

class Enemy2: Enemy{
    //MARK: PROPERTIES
    
    
    // MARK: - INIT
    override init(scene: GameScene){
        super.init(scene: scene)
        self.game.enemies.append(self)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    //MARK: - SETUP
    override func setup(){
        settexture(texturename: "ship (2)", size: CGSize(width: 60, height: 60))
        
        self.physicsBody = SKPhysicsBody(texture: self.texture!, size: self.size)
        physicsBody!.categoryBitMask = PhysicsCategory.Enemy
        physicsBody!.collisionBitMask = PhysicsCategory.Planet | PhysicsCategory.Asteroid | PhysicsCategory.Enemy | PhysicsCategory.Player
        physicsBody!.contactTestBitMask = PhysicsCategory.Laser | PhysicsCategory.Mine
        self.physicsBody?.fieldBitMask = PhysicsCategory.Explosion
        
        
        //set properties
        maxhealth = 100
        currenthealth = maxhealth

        
    }
    
    //MARK: - FUNCTIONALITY
    override func update(){
        super.update()
    }
}
