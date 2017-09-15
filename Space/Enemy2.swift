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
import GameplayKit

class Enemy2: Enemy{
    //MARK: PROPERTIES
    
    
    //damage
    var aimray: SKSpriteNode!
    var damage: CGFloat = 5
    var lasttimeshoot = NSDate()
    var shootingrarity = 0.25
    var laserspeed: CGFloat = 800
    
    var tracking = [SKShapeNode]()
    
  
    
    
    // MARK: - INIT
    override init(scene: GameScene){
        super.init(scene: scene)
        self.game.enemies.append(self)
        setup2()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    //MARK: - SETUP
    func setup2(){
        // set texture
        settexture(texturename: "ship (2)", size: CGSize(width: 60, height: 60))
        
        
        // set physics
        self.physicsBody = SKPhysicsBody(circleOfRadius: self.size.width / 2)
        physicsBody!.categoryBitMask = PhysicsCategory.Enemy
        physicsBody!.collisionBitMask = PhysicsCategory.Planet | PhysicsCategory.Asteroid | PhysicsCategory.Enemy | PhysicsCategory.Player
        physicsBody!.contactTestBitMask = PhysicsCategory.Laser | PhysicsCategory.Mine
        self.physicsBody?.fieldBitMask = PhysicsCategory.Explosion
        self.physicsBody?.linearDamping = 2.0
        
        //set properties
        thrusters = 5000
        rotatespeed = 0.2
        shootingrange = 200
        physicsBody?.mass = 10
        maxhealth = 100
        currenthealth = maxhealth
        
       
        
        //set aiming path
        if self.game.debug{
            aimray = SKSpriteNode(color: UIColor.blue, size: CGSize(width: 10, height: shootingrange))
        }
        else{
            aimray = SKSpriteNode(color: UIColor.clear, size: CGSize(width: 10, height: shootingrange))
            
        }
        self.addChild(aimray)
        aimray.position.y += shootingrange / 2 + self.size.height / 2 + 5
        
        
        
        
        
        
    }
    
    func autopilot(){
        
        
        

    }
    
    
    
    
    
    func updateaimraylength(){
        let game = self.game
        let chunk = self.parent as! Chunk
        let dx = (self.position.x + chunk.gridPos.x*chunk.size.width) - game!.Player.position.x
        let dy = (self.position.y + chunk.gridPos.y*chunk.size.height) - game!.Player.position.y
        var dist = sqrt(dx*dx + dy*dy)
        dist-=20
        if dist < shootingrange{
            let scale = SKAction.resize(toHeight: dist, duration: 0)
            aimray.position.y = dist / 2 + self.size.height / 2 + 5
            aimray.run(scale)
        }
        else{
            let scale = SKAction.resize(toHeight: shootingrange, duration: 0)
            aimray.position.y = shootingrange / 2 + self.size.height / 2 + 5
            aimray.run(scale)
        }
        
    }
    
    func shoot(){
        var canshoot = false
        var intersectsasteroid = false
        var intersectsplanet = false
        var intersectsenemy = false
        
        for planet in self.game.planets{
            if aimray.intersects(planet){
                intersectsplanet = true
            }
        }
        
        for enemy in self.game.enemies{
            if aimray.intersects(enemy){
                intersectsenemy = true
            }
        }
        
        for asteroid in self.game.asteroids{
            if aimray.intersects(asteroid){
                intersectsasteroid = true
            }
        }
        
        if lasttimeshoot.timeIntervalSinceNow < -shootingrarity && intersectsasteroid && !intersectsenemy{
            canshoot = true
        }
        
        if lasttimeshoot.timeIntervalSinceNow < -shootingrarity && !intersectsplanet && aimray.intersects(self.game.Player) && !intersectsenemy{
            canshoot = true
        }
        
        if canshoot{
            lasttimeshoot = NSDate()
            let laser = Laser(scene: self.game, laserlvl: 2, damage: self.damage ,speed: self.laserspeed, aimdirection: self.zRotation + CGFloat(Double.pi / 2))
            self.game.addChild(laser)
            let chunk = self.parent as! Chunk
            laser.position.x = self.position.x + chunk.gridPos.x*chunk.size.width + 40 * cos(zRotation + CGFloat(Double.pi / 2))
            laser.position.y = self.position.y + chunk.gridPos.y*chunk.size.height + 40 * sin(zRotation + CGFloat(Double.pi / 2))
            
        }
        
        
    }
    
    func managedebug(){
        if self.game.debug{
            aimray.color = UIColor.blue
        }
        else{
            aimray.color = UIColor.clear
            
        }
        
    }
    
    
    
    
    
    //MARK: - FUNCTIONALITY
    override func update(){
        managedebug()
        updateaimraylength()
        autopilot()
        
        shoot()
        super.update()
        
        
    }
}
